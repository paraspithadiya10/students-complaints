enum AppRoutes {
  splash('/splash'),
  login('/login'),
  home('/home'),
  studentList('/studentList');

  final String route;

  const AppRoutes(this.route);
}
