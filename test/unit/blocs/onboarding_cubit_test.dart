import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';

import 'package:video_streaming_app/features/onboarding/presentation/bloc/onboarding_cubit.dart';
import 'package:video_streaming_app/core/constants/app_constants.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  // Mock SharedPreferences
  const MethodChannel channel = MethodChannel('plugins.flutter.io/shared_preferences');
  final log = <MethodCall>[];

  setUp(() {
    log.clear();
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      log.add(methodCall);
      switch (methodCall.method) {
        case 'getAll':
          return <String, Object>{AppConstants.isOnboardedKey: false};
        case 'setBool':
          return true;
        default:
          return null;
      }
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  group('OnboardingCubit', () {
    late OnboardingCubit onboardingCubit;

    setUp(() {
      onboardingCubit = OnboardingCubit();
    });

    tearDown(() {
      onboardingCubit.close();
    });

    test('initial state should be OnboardingInitial', () {
      expect(onboardingCubit.state, isA<OnboardingInitial>());
    });

    blocTest<OnboardingCubit, OnboardingState>(
      'emits [OnboardingLoading, OnboardingIncomplete] when onboarding is not completed',
      build: () => onboardingCubit,
      act: (cubit) => cubit.checkOnboardingStatus(),
      expect: () => [isA<OnboardingLoading>(), isA<OnboardingIncomplete>()],
    );

    blocTest<OnboardingCubit, OnboardingState>(
      'emits [OnboardingLoading, OnboardingCompleted] when completing onboarding',
      build: () => onboardingCubit,
      act: (cubit) => cubit.completeOnboarding(),
      expect: () => [isA<OnboardingLoading>(), isA<OnboardingCompleted>()],
    );

    test('resetOnboarding emits OnboardingIncomplete', () {
      onboardingCubit.resetOnboarding();
      expect(onboardingCubit.state, isA<OnboardingIncomplete>());
    });
  });
}
