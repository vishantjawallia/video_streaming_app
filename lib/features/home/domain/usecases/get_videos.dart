import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/utils/either.dart';
import '../entities/video.dart';
import '../repositories/video_repository.dart';

class GetVideos implements UseCase<List<Video>, GetVideosParams> {
  final VideoRepository repository;

  const GetVideos(this.repository);

  @override
  Future<Either<Failure, List<Video>>> call(GetVideosParams params) async {
    return await repository.getVideos(category: params.category, search: params.search);
  }
}

class GetVideosParams extends Equatable {
  final String? category;
  final String? search;

  const GetVideosParams({this.category, this.search});

  @override
  List<Object?> get props => [category, search];
}

abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}
 