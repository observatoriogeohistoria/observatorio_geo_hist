import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:observatorio_geo_hist/app/core/infra/services/logger_service/logger_service.dart';
import 'package:observatorio_geo_hist/app/features/home/infra/errors/exceptions.dart';
import 'package:observatorio_geo_hist/app/features/home/infra/models/team_model.dart';

abstract class FetchTeamDatasource {
  Future<List<TeamMemberModel>> fetchTeam();
}

class FetchTeamDatasourceImpl implements FetchTeamDatasource {
  final FirebaseFirestore _firestore;
  final LoggerService _loggerService;

  FetchTeamDatasourceImpl(this._firestore, this._loggerService);

  @override
  Future<List<TeamMemberModel>> fetchTeam() async {
    try {
      QuerySnapshot querySnapshot = await _firestore.collection('team').get();

      final docs = querySnapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
      List<TeamMemberModel> team = docs.map((member) => TeamMemberModel.fromJson(member)).toList();

      return team;
    } catch (exception) {
      _loggerService.error('Error fetching team: $exception');
      throw const FetchTeamException();
    }
  }
}
