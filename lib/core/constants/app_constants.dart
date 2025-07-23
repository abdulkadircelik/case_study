class AppConstants {
  // App Info
  static const String appName = 'Case Study';
  static const String appVersion = '1.0.0';

  // API Constants
  static const String baseUrl = 'https://api.example.com';
  static const int connectionTimeout = 30000;
  static const int receiveTimeout = 30000;

  // Storage Keys
  static const String tokenKey = 'auth_token';
  static const String refreshTokenKey = 'refresh_token';
  static const String userKey = 'user_data';
  static const String languageKey = 'language';
  static const String themeKey = 'theme_mode';

  // Animation Durations
  static const Duration shortAnimation = Duration(milliseconds: 200);
  static const Duration mediumAnimation = Duration(milliseconds: 300);
  static const Duration longAnimation = Duration(milliseconds: 500);

  // Validation
  static const int minPasswordLength = 6;
  static const int maxPasswordLength = 50;

  // Social Login
  static const String googleClientId = 'your_google_client_id';
  static const String facebookAppId = 'your_facebook_app_id';
}
