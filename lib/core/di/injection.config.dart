// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:http/http.dart' as _i519;
import 'package:injectable/injectable.dart' as _i526;
import 'package:video_streaming_app/core/di/injection.dart' as _i720;
import 'package:video_streaming_app/features/auth/domain/repositories/auth_repository.dart'
    as _i392;
import 'package:video_streaming_app/features/auth/domain/usecases/login.dart'
    as _i1031;
import 'package:video_streaming_app/features/auth/presentation/bloc/auth_bloc.dart'
    as _i663;
import 'package:video_streaming_app/features/home/data/datasources/video_remote_data_source.dart'
    as _i733;
import 'package:video_streaming_app/features/home/domain/repositories/video_repository.dart'
    as _i618;
import 'package:video_streaming_app/features/home/domain/usecases/get_videos.dart'
    as _i895;
import 'package:video_streaming_app/features/home/presentation/bloc/home_bloc.dart'
    as _i690;
import 'package:video_streaming_app/features/onboarding/presentation/bloc/onboarding_cubit.dart'
    as _i625;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final appModule = _$AppModule();
    gh.lazySingleton<_i519.Client>(() => appModule.httpClient);
    gh.lazySingleton<_i733.VideoRemoteDataSource>(
      () => appModule.videoRemoteDataSource,
    );
    gh.lazySingleton<_i618.VideoRepository>(() => appModule.videoRepository);
    gh.lazySingleton<_i895.GetVideos>(() => appModule.getVideos);
    gh.lazySingleton<_i690.HomeBloc>(() => appModule.homeBloc);
    gh.lazySingleton<_i392.AuthRepository>(() => appModule.authRepository);
    gh.lazySingleton<_i1031.Login>(() => appModule.login);
    gh.lazySingleton<_i663.AuthBloc>(() => appModule.authBloc);
    gh.lazySingleton<_i625.OnboardingCubit>(() => appModule.onboardingCubit);
    return this;
  }
}

class _$AppModule extends _i720.AppModule {}
