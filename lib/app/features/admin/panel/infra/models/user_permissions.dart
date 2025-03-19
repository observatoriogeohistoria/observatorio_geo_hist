class UserPermissions {
  UserPermissions({
    this.canViewUsersSection = false,
    this.canEditUsersSection = false,
    this.canViewMediaSection = false,
    this.canEditMediaSection = false,
    this.canViewCategoriesSection = false,
    this.canEditCategoriesSection = false,
    this.canViewPostsSection = false,
    this.canEditPostsSection = false,
    this.canViewTeamSection = false,
    this.canEditTeamSection = false,
  });

  final bool canViewUsersSection;
  final bool canEditUsersSection;
  final bool canViewMediaSection;
  final bool canEditMediaSection;
  final bool canViewCategoriesSection;
  final bool canEditCategoriesSection;
  final bool canViewPostsSection;
  final bool canEditPostsSection;
  final bool canViewTeamSection;
  final bool canEditTeamSection;
}
