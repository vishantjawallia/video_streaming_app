import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:http/http.dart' as http;
import 'package:video_streaming_app/core/di/injection.config.dart';

import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/login.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';

import '../../features/home/data/datasources/video_remote_data_source.dart';
import '../../features/home/data/repositories/video_repository_impl.dart';
import '../../features/home/domain/repositories/video_repository.dart';
import '../../features/home/domain/usecases/get_videos.dart';
import '../../features/home/presentation/bloc/home_bloc.dart';

import '../../features/onboarding/presentation/bloc/onboarding_cubit.dart';

// part 'injection.config.dart';

final getIt = GetIt.instance;

@InjectableInit()
Future<void> configureDependencies() async => getIt.init();

@module
abstract class AppModule {
  @lazySingleton
  http.Client get httpClient => http.Client();

  @lazySingleton
  VideoRemoteDataSource get videoRemoteDataSource => VideoRemoteDataSourceImpl(client: httpClient);

  @lazySingleton
  VideoRepository get videoRepository => VideoRepositoryImpl(remoteDataSource: videoRemoteDataSource);

  @lazySingleton
  GetVideos get getVideos => GetVideos(videoRepository);

  @lazySingleton
  HomeBloc get homeBloc => HomeBloc(getVideos: getVideos);

  @lazySingleton
  AuthRepository get authRepository => const AuthRepositoryImpl();

  @lazySingleton
  Login get login => Login(authRepository);

  @lazySingleton
  AuthBloc get authBloc => AuthBloc(login: login);

  @lazySingleton
  OnboardingCubit get onboardingCubit => OnboardingCubit();
}
