/// Route path constants for the application
/// Use these constants instead of hardcoded strings for type-safety
class RouteConstants {
  RouteConstants._();

  // Root & Initial Routes
  static const String splash = '/';
  static const String onboarding = '/onboarding';

  // Auth Routes
  static const String login = '/login';
  static const String signup = '/signup';

  // Main App Routes (Protected)
  static const String dashboard = '/dashboard';
  static const String home = '/dashboard/home';
  static const String myItems = '/dashboard/my-items';
  static const String profile = '/dashboard/profile';

  // Item Routes
  static const String reportItem = '/report-item';
  static const String itemDetail = '/item/:id';

  // Batch Routes
  static const String batches = '/batches';
  static const String batchDetail = '/batch/:id';

  // Helper method to create item detail route with ID
  static String itemDetailWithId(String id) => '/item/$id';

  // Helper method to create batch detail route with ID
  static String batchDetailWithId(String id) => '/batch/$id';
}

/// Route names for analytics and debugging
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
