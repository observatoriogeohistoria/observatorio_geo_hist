import 'package:observatorio_geo_hist/app/core/models/academic_production_model.dart';
import 'package:observatorio_geo_hist/app/core/models/book_model.dart';
import 'package:observatorio_geo_hist/app/core/models/document_model.dart';
import 'package:observatorio_geo_hist/app/core/models/event_model.dart';
import 'package:observatorio_geo_hist/app/core/models/film_model.dart';
import 'package:observatorio_geo_hist/app/core/models/magazine_model.dart';
import 'package:observatorio_geo_hist/app/core/models/music_model.dart';
import 'package:observatorio_geo_hist/app/core/models/podcast_model.dart';
import 'package:observatorio_geo_hist/app/core/models/post_model.dart';
import 'package:observatorio_geo_hist/app/core/models/search_model.dart';
import 'package:observatorio_geo_hist/app/features/posts/presentation/components/post/work/event_day.dart';

enum WorkImageKind { cover, square, poster }

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

class WorkListen {
  const WorkListen({required this.label, required this.url, required this.host});

  final String label;
  final String url;
  final String host;
}

class WorkStatus {
  const WorkStatus({required this.label, required this.positive});

  final String label;
  final bool positive;
}

class WorkFigure {
  const WorkFigure({required this.url, required this.caption});

  final String url;
  final String caption;
}

class WorkInfo {
  const WorkInfo({
    required this.typeLabel,
    required this.badge,
    required this.title,
    required this.texts,
    this.teaser = '',
    this.facts = const [],
    this.wideFacts = const [],
    this.tagsLabel = '',
    this.tags = const [],
    this.image,
    this.date,
    this.action,
    this.listen,
    this.status,
    this.figure,
  });

  final String typeLabel;
  final String badge;
  final String title;
  final String teaser;
  final List<(String, String)> facts;
  final List<(String, String)> wideFacts;
  final String tagsLabel;
  final List<String> tags;
  final WorkImage? image;

  /// Ocupa o lugar da imagem: o evento não mostra o cartaz.
  final EventDay? date;
  final WorkAction? action;
  final WorkListen? listen;
  final WorkStatus? status;

  /// Imagem com legenda abaixo do compartilhar, como a do artigo.
  final WorkFigure? figure;
  final List<WorkText> texts;

  bool get hasSheet =>
      [...facts, ...wideFacts].any((fact) => fact.$2.trim().isNotEmpty) ||
      tags.any((tag) => tag.trim().isNotEmpty);
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
        texts: [WorkText(title: 'Sinopse', content: body.synopsis, isRich: false)],
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
        texts: [WorkText(title: 'Sinopse', content: body.synopsis, isRich: true)],
      ),
    MagazineModel() => WorkInfo(
        typeLabel: 'Revista',
        badge: body.category.portuguese,
        title: body.title,
        teaser: body.teaser ?? '',
        image: WorkImage(kind: WorkImageKind.cover, url: _url(body.image.url), link: ''),
        action: _action('Acessar revista', body.link),
        texts: [WorkText(title: 'Descrição', content: body.description, isRich: false)],
      ),
    DocumentModel() => WorkInfo(
        typeLabel: 'Documento',
        badge: body.category.portuguese,
        title: body.title,
        action: _action('Acessar documento', body.link),
        texts: [WorkText(title: 'Descrição', content: body.description, isRich: true)],
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
        texts: [WorkText(title: 'Resumo', content: body.summary, isRich: false)],
      ),
    PodcastModel() => WorkInfo(
        typeLabel: 'Podcast',
        badge: '',
        title: body.title,
        image: WorkImage(kind: WorkImageKind.square, url: _url(body.image.url), link: ''),
        listen: _listen('Ouvir episódio', body.link),
        texts: [WorkText(title: 'Descrição', content: body.description, isRich: false)],
      ),
    MusicModel() => WorkInfo(
        typeLabel: 'Música',
        badge: '',
        title: body.title,
        facts: [('Artista', body.artistName)],
        image: WorkImage(kind: WorkImageKind.square, url: _url(body.image.url), link: ''),
        listen: _listen('Ouvir música', body.link),
        texts: [
          WorkText(title: 'Descrição', content: body.description, isRich: false),
          WorkText(title: 'Letra', content: body.lyrics ?? '', isRich: true),
        ],
      ),
    EventModel() => WorkInfo(
        typeLabel: 'Evento',
        badge: '',
        title: body.title,
        date: eventDayOf(body.date),
        facts: [
          ('Data', body.date),
          ('Horário', body.time ?? ''),
          ('Local', body.location),
          ('Cidade', body.city),
          ('Abrangência', body.scope.portuguese),
        ],
        action: _action('Mais informações', body.link),
        texts: [WorkText(title: 'Detalhes', content: body.details ?? '', isRich: false)],
      ),
    SearchModel() => WorkInfo(
        typeLabel: 'Pesquisa',
        badge: '',
        title: body.title,
        status: WorkStatus(
          label: body.state.portuguese,
          positive: body.state == SearchState.inProgress,
        ),
        facts: [
          ('Coordenação', body.coordinator ?? ''),
          ('Pesquisador(a)', body.researcher ?? ''),
          ('Orientação', body.advisor ?? ''),
          ('Coorientação', body.coAdvisor ?? ''),
          ('Financiamento', body.financier ?? ''),
        ],
        wideFacts: [('Integrantes', body.members ?? '')],
        figure: _figure(body.image.url, body.imageCaption),
        texts: [WorkText(title: 'Descrição', content: body.description, isRich: false)],
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

WorkFigure? _figure(String? url, String caption) {
  final image = _url(url);
  return image.isEmpty ? null : WorkFigure(url: image, caption: caption);
}

WorkListen? _listen(String label, String url) {
  final link = url.trim();
  if (link.isEmpty) return null;

  final host = Uri.tryParse(link)?.host ?? '';
  return WorkListen(label: label, url: link, host: host.replaceFirst(RegExp('^www\\.'), ''));
}

WorkAction? _action(String label, String url) {
  final link = url.trim();
  return link.isEmpty ? null : WorkAction(label: label, url: link);
}
