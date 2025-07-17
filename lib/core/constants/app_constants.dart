class AppConstants {
  // API Endpoints
  static const String baseUrl = 'https://api.example.com';
  static const String videosEndpoint = '/videos';
  static const String categoriesEndpoint = '/categories';
  static const String authEndpoint = '/auth';

  // Shared Preferences Keys
  static const String isOnboardedKey = 'is_onboarded';
  static const String userTokenKey = 'user_token';
  static const String userProfileKey = 'user_profile';
  static const String themeModeKey = 'theme_mode';

  // Navigation Routes
  static const String splashRoute = '/';
  static const String onboardingRoute = '/onboarding';
  static const String loginRoute = '/login';
  static const String homeRoute = '/home';
  static const String videoDetailsRoute = '/video/:id';
  static const String profileRoute = '/profile';

  // Animation Durations
  static const Duration splashDuration = Duration(seconds: 3);
  static const Duration pageTransitionDuration = Duration(milliseconds: 300);

  // Video Player Settings
  static const List<double> playbackSpeeds = [0.5, 0.75, 1.0, 1.25, 1.5, 2.0];
  static const double defaultPlaybackSpeed = 1.0;

  // UI Constants
  static const double defaultPadding = 16.0;
  static const double defaultRadius = 8.0;
  static const double defaultElevation = 4.0;

  // Error Messages
  static const String networkErrorMessage = 'Network error occurred. Please check your connection.';
  static const String serverErrorMessage = 'Server error occurred. Please try again later.';
  static const String unknownErrorMessage = 'An unknown error occurred.';
}
