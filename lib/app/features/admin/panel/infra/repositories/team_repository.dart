import 'package:fpdart/fpdart.dart';
import 'package:observatorio_geo_hist/app/core/errors/failures.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/infra/datasources/team_datasource.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/infra/errors/team_failures.dart';
import 'package:observatorio_geo_hist/app/features/home/infra/models/team_model.dart';

abstract class TeamRepository {
  Future<Either<Failure, List<TeamMemberModel>>> getTeamMembers();
  Future<Either<Failure, TeamMemberModel>> createOrUpdateTeamMember(TeamMemberModel teamMember);
  Future<Either<Failure, TeamMemberModel>> deleteTeamMember(TeamMemberModel teamMember);
}

class TeamRepositoryImpl implements TeamRepository {
  final TeamDatasource _teamDatasource;

  TeamRepositoryImpl(this._teamDatasource);

  @override
  Future<Either<Failure, List<TeamMemberModel>>> getTeamMembers() async {
    try {
      final teamMembers = await _teamDatasource.getTeamMembers();
      return Right(teamMembers);
    } catch (error) {
      return const Left(GetTeamMembersFailure());
    }
  }

  @override
  Future<Either<Failure, TeamMemberModel>> createOrUpdateTeamMember(
    TeamMemberModel teamMember,
  ) async {
    try {
      final result = await _teamDatasource.createOrUpdateTeamMember(teamMember);
      return Right(result);
    } catch (error) {
      return const Left(CreateOrUpdateTeamMemberFailure());
    }
  }

  @override
  Future<Either<Failure, TeamMemberModel>> deleteTeamMember(TeamMemberModel teamMember) async {
    try {
      final result = await _teamDatasource.deleteTeamMember(teamMember);
      return Right(result);
    } catch (error) {
      return const Left(DeleteTeamMemberFailure());
    }
  }
}
