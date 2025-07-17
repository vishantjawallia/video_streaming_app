import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/constants/app_constants.dart';

part 'onboarding_state.dart';

class OnboardingCubit extends Cubit<OnboardingState> {
  OnboardingCubit() : super(OnboardingInitial());

  Future<void> checkOnboardingStatus() async {
    emit(OnboardingLoading());

    try {
      final prefs = await SharedPreferences.getInstance();
      final isOnboarded = prefs.getBool(AppConstants.isOnboardedKey) ?? false;

      if (isOnboarded) {
        emit(OnboardingCompleted());
      } else {
        emit(OnboardingIncomplete());
      }
    } catch (e) {
      emit(OnboardingError(e.toString()));
    }
  }

  Future<void> completeOnboarding() async {
    emit(OnboardingLoading());

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(AppConstants.isOnboardedKey, true);
      emit(OnboardingCompleted());
    } catch (e) {
      emit(OnboardingError(e.toString()));
    }
  }

  void resetOnboarding() {
    emit(OnboardingIncomplete());
  }
}
