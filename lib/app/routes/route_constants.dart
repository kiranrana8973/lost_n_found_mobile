class RouteConstants {
  RouteConstants._();

  static const String splash = '/';
  static const String onboarding = '/onboarding';

  static const String login = '/login';
  static const String signup = '/signup';

  static const String dashboard = '/dashboard';
  static const String home = '/dashboard/home';
  static const String myItems = '/dashboard/my-items';
  static const String profile = '/dashboard/profile';

  static const String reportItem = '/report-item';
  static const String itemDetail = '/item/:id';

  static const String batches = '/batches';
  static const String batchDetail = '/batch/:id';

  static String itemDetailWithId(String id) => '/item/$id';

  static String batchDetailWithId(String id) => '/batch/$id';
}

class RouteNames {
  RouteNames._();

  static const String splash = 'splash';
  static const String onboarding = 'onboarding';
  static const String login = 'login';
  static const String signup = 'signup';
  static const String dashboard = 'dashboard';
  static const String home = 'home';
  static const String myItems = 'myItems';
  static const String profile = 'profile';
  static const String reportItem = 'reportItem';
  static const String itemDetail = 'itemDetail';
  static const String batches = 'batches';
  static const String batchDetail = 'batchDetail';
}
