import 'package:mobx/mobx.dart';
import 'package:observatorio_geo_hist/app/features/home/infra/models/team_model.dart';
import 'package:observatorio_geo_hist/app/features/home/infra/repositories/fetch_team_repository.dart';

part 'fetch_team_store.g.dart';

class FetchTeamStore = FetchTeamStoreBase with _$FetchTeamStore;

abstract class FetchTeamStoreBase with Store {
  final FetchTeamRepository _repository;

  FetchTeamStoreBase(this._repository);

  @observable
  ObservableList<TeamMemberModel> team = ObservableList<TeamMemberModel>();

  @action
  Future<void> fetchTeam() async {
    final result = await _repository.fetchTeam();
    result.fold(
      (failure) {},
      (team) => this.team = ObservableList.of(team),
    );
  }
}
