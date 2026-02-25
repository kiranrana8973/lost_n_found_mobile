class AppConstants {
  AppConstants._();

  // App Info
  static const String appName = 'Lost & Found';
  static const String appVersion = '1.0.0';

  // Pagination
  static const int defaultPageSize = 20;

  // Validation
  static const int minPasswordLength = 6;
  static const int maxNameLength = 50;
  static const int maxDescriptionLength = 500;

  // Timeouts (in seconds)
  static const int splashDuration = 2;
  static const int snackbarDuration = 2;

  // Storage Keys
  static const String hasSeenOnboardingKey = 'has_seen_onboarding';

  // Supported Languages
  static const String englishCode = 'en';
  static const String nepaliCode = 'ne';
}
