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

  /// Não repete a consulta quando o usuário volta igual; depois de criar ou excluir, use [refresh].
  @action
  Future<void> load({required bool includeUsers}) async {
    if (_includeUsers == includeUsers) return;
    _includeUsers = includeUsers;
    counts = await _repository.getCounts(includeUsers: includeUsers);
  }

  /// Depois de criar ou excluir. Os números antigos ficam até chegarem os novos.
  @action
  Future<void> refresh() async {
    final includeUsers = _includeUsers;
    if (includeUsers == null) return;
    counts = await _repository.getCounts(includeUsers: includeUsers);
  }
}
