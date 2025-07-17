import '../../../../core/errors/failures.dart';
import '../../../../core/utils/either.dart';
import '../entities/video.dart';

abstract class VideoRepository {
  Future<Either<Failure, List<Video>>> getVideos({String? category, String? search});
  Future<Either<Failure, Video>> getVideoById(String id);
  Future<Either<Failure, List<String>>> getCategories();
}
