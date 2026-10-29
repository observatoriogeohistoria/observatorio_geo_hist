import 'package:observatorio_geo_hist/app/core/models/post_model.dart';

extension PostTypeEditorLabels on PostType {
  String get editorNewTitle => switch (this) {
        PostType.article => 'Novo artigo',
        PostType.academicProduction => 'Nova produção acadêmica',
        PostType.book => 'Novo livro',
        PostType.document => 'Novo documento',
        PostType.event => 'Novo evento',
        PostType.film => 'Novo filme',
        PostType.magazine => 'Nova revista',
        PostType.music => 'Nova música',
        PostType.podcast => 'Novo podcast',
        PostType.search => 'Nova pesquisa',
      };

  String get editorEditTitle => switch (this) {
        PostType.article => 'Editar artigo',
        PostType.academicProduction => 'Editar produção acadêmica',
        PostType.book => 'Editar livro',
        PostType.document => 'Editar documento',
        PostType.event => 'Editar evento',
        PostType.film => 'Editar filme',
        PostType.magazine => 'Editar revista',
        PostType.music => 'Editar música',
        PostType.podcast => 'Editar podcast',
        PostType.search => 'Editar pesquisa',
      };
}
