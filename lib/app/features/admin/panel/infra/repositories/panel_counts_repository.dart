import 'package:observatorio_geo_hist/app/core/models/post_model.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/infra/datasources/panel_counts_datasource.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/infra/models/panel_counts.dart';
import 'package:observatorio_geo_hist/app/features/library/infra/models/library_document_model.dart';

abstract class PanelCountsRepository {
  Future<PanelCounts> getCounts({required bool includeUsers});
}

class PanelCountsRepositoryImpl implements PanelCountsRepository {
  final PanelCountsDatasource _datasource;

  PanelCountsRepositoryImpl(this._datasource);

  @override
  Future<PanelCounts> getCounts({required bool includeUsers}) async {
    final posts = Future.wait(PostType.values.map((type) => _orNull(_datasource.countPosts(type))));
    final library = Future.wait(
      DocumentArea.values.map((area) => _orNull(_datasource.countLibraryDocuments(area))),
    );
    final categories = _orNull(_datasource.countCategories());
    final team = _orNull(_datasource.countTeamMembers());
    final users = includeUsers ? _orNull(_datasource.countActiveUsers()) : Future.value(null);

    final postsCounts = await posts;
    final libraryCounts = await library;

    return PanelCounts(
      postsByType: Map.fromIterables(PostType.values, postsCounts),
      libraryByArea: Map.fromIterables(DocumentArea.values, libraryCounts),
      categories: await categories,
      team: await team,
      users: await users,
    );
  }

  // Cada contagem falha sozinha: o datasource já registrou o erro, e só aquele número some.
  Future<int?> _orNull(Future<int> count) async {
    try {
      return await count;
    } catch (_) {
      return null;
    }
  }
}
