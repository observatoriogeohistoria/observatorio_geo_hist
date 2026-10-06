import 'package:observatorio_geo_hist/app/core/models/academic_production_model.dart';
import 'package:observatorio_geo_hist/app/core/models/book_model.dart';
import 'package:observatorio_geo_hist/app/core/models/document_model.dart';
import 'package:observatorio_geo_hist/app/core/models/film_model.dart';
import 'package:observatorio_geo_hist/app/core/models/magazine_model.dart';
import 'package:observatorio_geo_hist/app/core/models/post_model.dart';

enum WorkImageKind { cover, poster }

class WorkImage {
  const WorkImage({required this.kind, required this.url, required this.link});

  final WorkImageKind kind;
  final String url;

  /// Só o cartaz usa: o "Assistir" sobre ele abre o link.
  final String link;
}

class WorkAction {
  const WorkAction({required this.label, required this.url});

  final String label;
  final String url;
}

class WorkText {
  const WorkText({required this.title, required this.content, required this.isRich});

  final String title;
  final String content;
  final bool isRich;
}

class WorkInfo {
  const WorkInfo({
    required this.typeLabel,
    required this.badge,
    required this.title,
    required this.text,
    this.teaser = '',
    this.facts = const [],
    this.tagsLabel = '',
    this.tags = const [],
    this.image,
    this.action,
  });

  final String typeLabel;
  final String badge;
  final String title;
  final String teaser;
  final List<(String, String)> facts;
  final String tagsLabel;
  final List<String> tags;
  final WorkImage? image;
  final WorkAction? action;
  final WorkText text;

  bool get hasSheet =>
      facts.any((fact) => fact.$2.trim().isNotEmpty) || tags.any((tag) => tag.trim().isNotEmpty);
}

WorkInfo workInfoOf(PostModel post) {
  final body = post.body;

  return switch (body) {
    BookModel() => WorkInfo(
        typeLabel: 'Livro',
        badge: body.category.portuguese,
        title: body.title,
        facts: [('Autoria', body.author), ('Ano', _year(body.year)), ('Editora', body.publisher)],
        image: WorkImage(kind: WorkImageKind.cover, url: _url(body.image.url), link: ''),
        action: _action('Acessar livro', body.link),
        text: WorkText(title: 'Sinopse', content: body.synopsis, isRich: false),
      ),
    FilmModel() => WorkInfo(
        typeLabel: 'Filme',
        badge: body.category.portuguese,
        title: body.title,
        facts: [
          ('Direção', body.director),
          ('País', body.country),
          ('Ano', _year(body.releaseYear)),
          ('Duração', body.duration),
        ],
        image: WorkImage(kind: WorkImageKind.poster, url: _url(body.image.url), link: body.link),
        text: WorkText(title: 'Sinopse', content: body.synopsis, isRich: true),
      ),
    MagazineModel() => WorkInfo(
        typeLabel: 'Revista',
        badge: body.category.portuguese,
        title: body.title,
        teaser: body.teaser ?? '',
        image: WorkImage(kind: WorkImageKind.cover, url: _url(body.image.url), link: ''),
        action: _action('Acessar revista', body.link),
        text: WorkText(title: 'Descrição', content: body.description, isRich: false),
      ),
    DocumentModel() => WorkInfo(
        typeLabel: 'Documento',
        badge: body.category.portuguese,
        title: body.title,
        action: _action('Acessar documento', body.link),
        text: WorkText(title: 'Descrição', content: body.description, isRich: true),
      ),
    AcademicProductionModel() => WorkInfo(
        typeLabel: 'Produção acadêmica',
        badge: body.category.portuguese,
        title: body.title,
        facts: [
          ('Autoria', body.author),
          ('Orientação', body.advisor),
          ('Instituição', body.institution),
          ('Cidade e ano', body.yearAndCity),
        ],
        tagsLabel: 'Palavras-chave',
        tags: _keywords(body.keywords),
        action: _action('Acessar produção', body.link),
        text: WorkText(title: 'Resumo', content: body.summary, isRich: false),
      ),
    _ => throw ArgumentError.value(post.type, 'post.type', 'não é uma obra'),
  };
}

List<String> _keywords(String keywords) => [
      for (final term in keywords.split(RegExp('[,;]')))
        term.trim().replaceFirst(RegExp(r'\.+$'), '').trim(),
    ];

String _year(int year) => year > 0 ? '$year' : '';

String _url(String? url) => url?.trim() ?? '';

WorkAction? _action(String label, String url) {
  final link = url.trim();
  return link.isEmpty ? null : WorkAction(label: label, url: link);
}
