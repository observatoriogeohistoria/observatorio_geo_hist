import 'package:mobx/mobx.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/infra/models/panel_counts.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/infra/repositories/panel_counts_repository.dart';

part 'panel_counts_store.g.dart';

class PanelCountsStore = PanelCountsStoreBase with _$PanelCountsStore;

abstract class PanelCountsStoreBase with Store {
  final PanelCountsRepository _repository;

  PanelCountsStoreBase(this._repository);

  @observable
  PanelCounts counts = const PanelCounts();

  bool? _includeUsers;

  /// Doesn't repeat the query when the same user comes back; after creating or deleting, use [refresh].
  @action
  Future<void> load({required bool includeUsers}) async {
    if (_includeUsers == includeUsers) return;
    _includeUsers = includeUsers;
    counts = await _repository.getCounts(includeUsers: includeUsers);
  }

  /// After creating or deleting. The old numbers stay until the new ones arrive.
  @action
  Future<void> refresh() async {
    final includeUsers = _includeUsers;
    if (includeUsers == null) return;
    counts = await _repository.getCounts(includeUsers: includeUsers);
  }
}
