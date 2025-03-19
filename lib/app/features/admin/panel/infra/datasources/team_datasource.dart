import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:observatorio_geo_hist/app/core/infra/services/logger_service/logger_service.dart';
import 'package:observatorio_geo_hist/app/core/utils/generator/id_generator.dart';
import 'package:observatorio_geo_hist/app/features/home/infra/models/team_model.dart';

abstract class TeamDatasource {
  Future<List<TeamMemberModel>> getTeamMembers();
  Future<TeamMemberModel> createOrUpdateTeamMember(TeamMemberModel teamMember);
  Future<TeamMemberModel> deleteTeamMember(TeamMemberModel teamMember);
}

class TeamDatasourceImpl implements TeamDatasource {
  final FirebaseFirestore _firestore;
  final LoggerService _loggerService;

  TeamDatasourceImpl(this._firestore, this._loggerService);

  @override
  Future<List<TeamMemberModel>> getTeamMembers() async {
    try {
      QuerySnapshot querySnapshot = await _firestore.collection('team').orderBy('name').get();

      final docs = querySnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return data;
      }).toList();

      List<TeamMemberModel> members = docs.map((user) => TeamMemberModel.fromJson(user)).toList();

      return members;
    } catch (exception, stackTrace) {
      _loggerService.error('Error fetching team members: $exception', stackTrace: stackTrace);
      rethrow;
    }
  }

  @override
  Future<TeamMemberModel> createOrUpdateTeamMember(TeamMemberModel teamMember) async {
    try {
      final newTeamMember = teamMember.copyWith(id: teamMember.id ?? IdGenerator.generate());

      DocumentReference ref = _firestore.collection('team').doc(newTeamMember.id);
      await ref.set(newTeamMember.toJson(), SetOptions(merge: true));

      return newTeamMember;
    } catch (exception, stackTrace) {
      _loggerService.error('Error creating or updating team member: $exception',
          stackTrace: stackTrace);
      rethrow;
    }
  }

  @override
  Future<TeamMemberModel> deleteTeamMember(TeamMemberModel teamMember) async {
    try {
      DocumentReference ref = _firestore.collection('team').doc(teamMember.id);
      await ref.delete();

      return teamMember;
    } catch (exception, stackTrace) {
      _loggerService.error('Error deleting team member: $exception', stackTrace: stackTrace);
      rethrow;
    }
  }
}
