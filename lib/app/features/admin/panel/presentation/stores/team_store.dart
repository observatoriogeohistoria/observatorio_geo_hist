import 'package:mobx/mobx.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/infra/repositories/team_repository.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/stores/states/team_states.dart';
import 'package:observatorio_geo_hist/app/features/home/infra/models/team_model.dart';

part 'team_store.g.dart';

class TeamStore = TeamStoreBase with _$TeamStore;

abstract class TeamStoreBase with Store {
  final TeamRepository _teamRepository;

  TeamStoreBase(this._teamRepository);

  @observable
  ObservableList<TeamMemberModel> teamMembers = ObservableList<TeamMemberModel>();

  @observable
  ManageTeamState state = ManageTeamInitialState();

  @action
  Future<void> getTeamMembers() async {
    if (state is ManageTeamLoadingState) return;
    if (teamMembers.isNotEmpty) return;

    state = ManageTeamLoadingState();

    final result = await _teamRepository.getTeamMembers();

    result.fold(
      (failure) => state = ManageTeamErrorState(failure),
      (teamMembers) {
        this.teamMembers = teamMembers.asObservable();
        state = ManageTeamSuccessState();
      },
    );
  }

  @action
  Future<void> createOrUpdateTeamMember(TeamMemberModel teamMember) async {
    state = ManageTeamLoadingState(isRefreshing: true);

    final result = await _teamRepository.createOrUpdateTeamMember(teamMember);

    result.fold(
      (failure) => state = ManageTeamErrorState(failure),
      (data) {
        final index = teamMembers.indexWhere((c) => c.id == data.id);
        index >= 0 ? teamMembers.replaceRange(index, index + 1, [data]) : teamMembers.add(data);

        state = ManageTeamSuccessState(
          message: index >= 0 ? 'Membro atualizado com sucesso' : 'Membro criado com sucesso',
        );
      },
    );
  }

  @action
  Future<void> deleteTeamMember(TeamMemberModel teamMember) async {
    state = ManageTeamLoadingState(isRefreshing: true);

    final result = await _teamRepository.deleteTeamMember(teamMember);

    result.fold(
      (failure) => state = ManageTeamErrorState(failure),
      (_) {
        teamMembers.removeWhere((c) => c.id == teamMember.id);
        state = ManageTeamSuccessState(message: 'Membro deletado com sucesso');
      },
    );
  }
}
