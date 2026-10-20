import 'package:observatorio_geo_hist/app/features/admin/panel/infra/models/user_role.dart';

extension UserRoleLabel on UserRole {
  String get label => switch (this) {
        UserRole.admin => 'Administração',
        UserRole.editor => 'Edição',
        UserRole.viewer => 'Leitura',
      };

  String get description => switch (this) {
        UserRole.admin => 'Tudo, inclusive criar e remover usuários.',
        UserRole.editor => 'Cria, edita e publica conteúdo.',
        UserRole.viewer => 'Só vê o painel, sem alterar nada.',
      };
}
