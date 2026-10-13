import 'package:observatorio_geo_hist/app/features/admin/panel/infra/models/user_role.dart';

extension UserRoleLabel on UserRole {
  String get label => switch (this) {
        UserRole.admin => 'Administração',
        UserRole.editor => 'Edição',
        UserRole.viewer => 'Leitura',
      };
}
