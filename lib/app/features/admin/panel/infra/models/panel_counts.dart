import 'package:observatorio_geo_hist/app/core/models/post_model.dart';
import 'package:observatorio_geo_hist/app/features/library/infra/models/library_document_model.dart';

/// Cada número é `null` enquanto carrega ou quando a consulta falhou; o menu então não o mostra.
class PanelCounts {
  const PanelCounts({
    this.postsByType = const {},
    this.categories,
    this.libraryByArea = const {},
    this.team,
    this.users,
  });

  final Map<PostType, int?> postsByType;
  final int? categories;
  final Map<DocumentArea, int?> libraryByArea;
  final int? team;
  final int? users;

  int? posts(PostType type) => postsByType[type];

  int? get postsTotal => _sumAll(PostType.values.map(posts));

  int? get libraryTotal => _sumAll(DocumentArea.values.map((area) => libraryByArea[area]));

  // Um total com parte faltando mostraria um número errado; melhor não mostrar.
  static int? _sumAll(Iterable<int?> values) {
    var total = 0;
    for (final value in values) {
      if (value == null) return null;
      total += value;
    }
    return total;
  }
}
