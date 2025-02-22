import 'package:fpdart/fpdart.dart';
import 'package:observatorio_geo_hist/app/core/errors/failures.dart';
import 'package:observatorio_geo_hist/app/features/home/infra/datasources/fetch_team_datasource.dart';
import 'package:observatorio_geo_hist/app/features/home/infra/errors/failures.dart';
import 'package:observatorio_geo_hist/app/features/home/infra/models/team_model.dart';

abstract class FetchTeamRepository {
  Future<Either<Failure, List<TeamMemberModel>>> fetchTeam();
}

class FetchTeamRepositoryImpl implements FetchTeamRepository {
  final FetchTeamDatasource _datasource;

  FetchTeamRepositoryImpl(this._datasource);

  @override
  Future<Either<Failure, List<TeamMemberModel>>> fetchTeam() async {
    try {
      final team = await _datasource.fetchTeam();
      return Right(team);
    } catch (error) {
      return const Left(FetchTeamFailure());
    }
  }
}
