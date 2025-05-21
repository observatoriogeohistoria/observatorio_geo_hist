import 'package:mobx/mobx.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/infra/repositories/team_repository.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/stores/crud_store.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/stores/states/crud_states.dart';
import 'package:observatorio_geo_hist/app/features/home/infra/models/team_model.dart';

part 'team_store.g.dart';

class TeamStore = TeamStoreBase with _$TeamStore;

abstract class TeamStoreBase extends CrudStore<TeamMemberModel> with Store {
  final TeamRepository _teamRepository;

  TeamStoreBase(this._teamRepository);

  @override
  @observable
  ObservableList<TeamMemberModel> items = ObservableList<TeamMemberModel>();

  @override
  @observable
  CrudState state = CrudInitialState();

  @override
  @action
  Future<void> getItems() async {
    if (state is CrudLoadingState) return;
    if (items.isNotEmpty) return;

    state = CrudLoadingState();

    final result = await _teamRepository.getTeamMembers();

    result.fold(
      (failure) => state = CrudErrorState(failure),
      (teamMembers) {
        items = teamMembers.asObservable();
        state = CrudSuccessState();
      },
    );
  }

  @override
  @action
  Future<void> createOrUpdateItem(TeamMemberModel item, {dynamic extra}) async {
    state = CrudLoadingState(isRefreshing: true);

    final result = await _teamRepository.createOrUpdateTeamMember(item);

    result.fold(
      (failure) => state = CrudErrorState(failure),
      (data) {
        final index = items.indexWhere((c) => c.id == data.id);
        index >= 0 ? items.replaceRange(index, index + 1, [data]) : items.add(data);

        state = CrudSuccessState(
          message: index >= 0 ? 'Membro atualizado com sucesso' : 'Membro criado com sucesso',
        );
      },
    );
  }

  @override
  @action
  Future<void> deleteItem(TeamMemberModel item) async {
    state = CrudLoadingState(isRefreshing: true);

    final result = await _teamRepository.deleteTeamMember(item);

    result.fold(
      (failure) => state = CrudErrorState(failure),
      (_) {
        items.removeWhere((c) => c.id == item.id);
        state = CrudSuccessState(message: 'Membro deletado com sucesso');
      },
    );
  }
}
