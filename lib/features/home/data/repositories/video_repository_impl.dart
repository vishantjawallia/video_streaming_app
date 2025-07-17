import 'package:video_streaming_app/core/utils/either.dart';

import '../../../../core/errors/failures.dart';
import '../../domain/entities/video.dart';
import '../../domain/repositories/video_repository.dart';
import '../datasources/video_remote_data_source.dart';
import '../models/video_model.dart';

class VideoRepositoryImpl implements VideoRepository {
  final VideoRemoteDataSource remoteDataSource;

  const VideoRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<Video>>> getVideos({String? category, String? search}) async {
    try {
      final videoModels = await remoteDataSource.getVideos(category: category, search: search);
      return Either.right(videoModels);
    } catch (e) {
      return Either.left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Video>> getVideoById(String id) async {
    try {
      final videoModel = await remoteDataSource.getVideoById(id);
      return Either.right(videoModel);
    } catch (e) {
      return Either.left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<String>>> getCategories() async {
    try {
      final categories = await remoteDataSource.getCategories();
      return Either.right(categories);
    } catch (e) {
      return Either.left(ServerFailure(e.toString()));
    }
  }
} 