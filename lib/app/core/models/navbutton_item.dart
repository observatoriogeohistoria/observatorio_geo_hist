class NavButtonItem {
  NavButtonItem({
    required this.title,
    required this.route,
    this.options,
  });

  final String title;
  final String route;
  final List<NavButtonItem>? options;
}
