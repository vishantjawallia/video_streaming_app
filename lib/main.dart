import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:go_router/go_router.dart';

// Core
import 'core/router/app_router.dart';
import 'core/constants/app_constants.dart';
import 'core/config/env_config.dart';
import 'core/di/injection.dart';
import 'core/theme/app_theme.dart';

// Features
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/home/presentation/bloc/home_bloc.dart';
import 'features/onboarding/presentation/bloc/onboarding_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables
  await EnvConfig.load();

  // Initialize dependency injection
  await configureDependencies();

  // Initialize adaptive theme
  final savedThemeMode = await AdaptiveTheme.getThemeMode();

  runApp(MyApp(savedThemeMode: savedThemeMode));
}

class MyApp extends StatelessWidget {
  final AdaptiveThemeMode? savedThemeMode;

  const MyApp({super.key, this.savedThemeMode});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812), // iPhone X design size
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return AdaptiveTheme(
          light: AppTheme.lightTheme,
          dark: AppTheme.darkTheme,
          initial: savedThemeMode ?? AdaptiveThemeMode.light,
          builder:
              (theme, darkTheme) => MultiBlocProvider(
                providers: [
                  // Home BLoC
                  BlocProvider<HomeBloc>.value(value: getIt<HomeBloc>()),
                  // Auth BLoC
                  BlocProvider<AuthBloc>.value(value: getIt<AuthBloc>()),
                  // Onboarding Cubit
                  BlocProvider<OnboardingCubit>.value(value: getIt<OnboardingCubit>()),
                ],
                child: MaterialApp.router(title: EnvConfig.appName, theme: theme, darkTheme: darkTheme, routerConfig: AppRouter.router, debugShowCheckedModeBanner: false),
              ),
        );
      },
    );
  }
}
