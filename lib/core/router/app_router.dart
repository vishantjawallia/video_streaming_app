import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/splash/presentation/screens/splash_screen.dart';
import '../../features/onboarding/presentation/screens/onboarding_screen.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/video_player/presentation/screens/video_details_screen.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(path: '/', name: 'splash', builder: (context, state) => const SplashScreen()),
      GoRoute(path: '/onboarding', name: 'onboarding', builder: (context, state) => const OnboardingScreen()),
      GoRoute(path: '/login', name: 'login', builder: (context, state) => const LoginScreen()),
      GoRoute(path: '/home', name: 'home', builder: (context, state) => const HomeScreen()),
      GoRoute(
        path: '/video/:id',
        name: 'video_details',
        builder: (context, state) {
          final videoId = state.pathParameters['id']!;
          return VideoDetailsScreen(videoId: videoId);
        },
      ),
      GoRoute(path: '/profile', name: 'profile', builder: (context, state) => const ProfileScreen()),
    ],
  );
}
