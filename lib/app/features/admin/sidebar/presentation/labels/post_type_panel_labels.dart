import 'package:observatorio_geo_hist/app/core/models/post_model.dart';

/// Panel labels. The site's plural ("Filmes e Vídeos") is too long for the menu.
extension PostTypePanelLabels on PostType {
  static const List<PostType> menuOrder = [
    PostType.article,
    PostType.academicProduction,
    PostType.book,
    PostType.document,
    PostType.event,
    PostType.film,
    PostType.magazine,
    PostType.music,
    PostType.podcast,
    PostType.search,
  ];

  String get panelPlural => switch (this) {
        PostType.article => 'Artigos',
        PostType.academicProduction => 'Produções acadêmicas',
        PostType.book => 'Livros',
        PostType.document => 'Documentos',
        PostType.event => 'Eventos',
        PostType.film => 'Filmes',
        PostType.magazine => 'Revistas',
        PostType.music => 'Músicas',
        PostType.podcast => 'Podcasts',
        PostType.search => 'Pesquisas',
      };

  String get panelCreateLabel => switch (this) {
        PostType.article => 'Novo artigo',
        PostType.academicProduction => 'Nova produção',
        PostType.book => 'Novo livro',
        PostType.document => 'Novo documento',
        PostType.event => 'Novo evento',
        PostType.film => 'Novo filme',
        PostType.magazine => 'Nova revista',
        PostType.music => 'Nova música',
        PostType.podcast => 'Novo podcast',
        PostType.search => 'Nova pesquisa',
      };
}
