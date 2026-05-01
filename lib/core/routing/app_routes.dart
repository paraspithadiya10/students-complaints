enum AppRoutes {
  splash('/splash'),
  login('/login'),
  home('/home'),
  studentList('/studentList'),
  studentDetail('/studentDetail'),
  editStudentDetail('/editStudentDetail'),
  complaint('/complaint'),
  profile('/profile');

  final String route;

  const AppRoutes(this.route);
}
