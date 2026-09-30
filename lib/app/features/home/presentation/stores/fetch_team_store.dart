import 'package:collection/collection.dart';
import 'package:mobx/mobx.dart';
import 'package:observatorio_geo_hist/app/features/home/infra/models/team_model.dart';
import 'package:observatorio_geo_hist/app/features/home/infra/repositories/fetch_team_repository.dart';
import 'package:observatorio_geo_hist/app/features/home/presentation/components/team/sort_team.dart';
import 'package:observatorio_geo_hist/app/features/home/presentation/stores/states/fetch_team_states.dart';

part 'fetch_team_store.g.dart';

class FetchTeamStore = FetchTeamStoreBase with _$FetchTeamStore;

abstract class FetchTeamStoreBase with Store {
  final FetchTeamRepository _repository;

  FetchTeamStoreBase(this._repository);

  /// Membros em ordem alfabética do nome.
  @observable
  ObservableList<TeamMemberModel> team = ObservableList<TeamMemberModel>();

  @observable
  FetchTeamState state = FetchTeamInitialState();

  /// Ainda não buscou ou a última busca falhou. Evita o esqueleto piscar ao voltar à Home.
  bool get needsFetch => switch (state) {
        FetchTeamInitialState() || FetchTeamErrorState() => true,
        FetchTeamLoadingState() || FetchTeamSuccessState() => false,
      };

  @action
  Future<void> fetchTeam() async {
    state = FetchTeamLoadingState();

    final result = await _repository.fetchTeam();

    result.fold(
      (failure) {
        state = FetchTeamErrorState(failure.message);
      },
      (team) {
        this.team = sortTeamByName(team).asObservable();
        state = FetchTeamSuccessState();
      },
    );
  }

  TeamMemberModel? getTeamMemberById(String id) {
    return team.firstWhereOrNull((member) => member.id == id);
  }
}
