class UserPermissions {
  UserPermissions({
    this.canAccessUsersSection = false,
    this.canEditMediaSection = false,
    this.canEditCategoriesSection = false,
    this.canEditPostsSection = false,
    this.canEditTeamSection = false,
    this.canEditLibrarySection = false,
  });

  final bool canAccessUsersSection;
  final bool canEditMediaSection;
  final bool canEditCategoriesSection;
  final bool canEditPostsSection;
  final bool canEditTeamSection;
  final bool canEditLibrarySection;
}
