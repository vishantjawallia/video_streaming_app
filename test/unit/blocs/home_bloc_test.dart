import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';

import 'package:video_streaming_app/features/home/domain/entities/video.dart';
import 'package:video_streaming_app/features/home/domain/usecases/get_videos.dart';
import 'package:video_streaming_app/features/home/domain/repositories/video_repository.dart';
import 'package:video_streaming_app/features/home/presentation/bloc/home_bloc.dart';
import 'package:video_streaming_app/core/errors/failures.dart';
import 'package:video_streaming_app/core/utils/either.dart';

// Mock GetVideos for testing
class MockGetVideos extends GetVideos {
  final List<Video>? videos;
  final Failure? failure;

  MockGetVideos({this.videos, this.failure}) : super(const MockVideoRepository());

  @override
  Future<Either<Failure, List<Video>>> call(GetVideosParams params) async {
    if (failure != null) {
      return Either.left(failure!);
    }
    return Either.right(videos ?? []);
  }
}

// Mock repository for testing
class MockVideoRepository implements VideoRepository {
  const MockVideoRepository();

  @override
  Future<Either<Failure, List<Video>>> getVideos({String? category, String? search}) async {
    return Either.right([]);
  }

  @override
  Future<Either<Failure, Video>> getVideoById(String id) async {
    return Either.right(
      Video(
        id: id,
        title: 'Test Video',
        description: 'Test Description',
        thumbnailUrl: 'https://example.com/thumb.jpg',
        videoUrl: 'https://example.com/video.mp4',
        category: 'Test',
        views: 1000,
        likes: 100,
        author: 'Test Author',
        createdAt: DateTime.now(),
        duration: Duration(minutes: 5),
      ),
    );
  }

  @override
  Future<Either<Failure, List<String>>> getCategories() async {
    return Either.right(['All', 'Education', 'Programming']);
  }
}

void main() {
  group('HomeBloc', () {
    late HomeBloc homeBloc;

    setUp(() {
      homeBloc = HomeBloc(
        getVideos: MockGetVideos(
          videos: [
            Video(
              id: '1',
              title: 'Test Video',
              description: 'Test Description',
              thumbnailUrl: 'https://example.com/thumb.jpg',
              videoUrl: 'https://example.com/video.mp4',
              category: 'Test',
              views: 1000,
              likes: 100,
              author: 'Test Author',
              createdAt: DateTime.now(),
              duration: Duration(minutes: 5),
            ),
          ],
        ),
      );
    });

    tearDown(() {
      homeBloc.close();
    });

    test('initial state should be HomeInitial', () {
      expect(homeBloc.state, isA<HomeInitial>());
    });

    blocTest<HomeBloc, HomeState>(
      'emits [HomeLoading, HomeLoaded] when LoadVideos is successful',
      build: () => homeBloc,
      act: (bloc) => bloc.add(const LoadVideos()),
      expect: () => [isA<HomeLoading>(), isA<HomeLoaded>()],
    );

    blocTest<HomeBloc, HomeState>(
      'emits [HomeLoading, HomeError] when LoadVideos fails',
      build: () {
        return HomeBloc(getVideos: MockGetVideos(failure: const ServerFailure('Server error')));
      },
      act: (bloc) => bloc.add(const LoadVideos()),
      expect: () => [isA<HomeLoading>(), isA<HomeError>()],
    );

    blocTest<HomeBloc, HomeState>(
      'emits [HomeLoading, HomeLoaded] when SearchVideos is successful',
      build: () => homeBloc,
      act: (bloc) => bloc.add(const SearchVideos('test')),
      expect: () => [isA<HomeLoading>(), isA<HomeLoaded>()],
    );

    blocTest<HomeBloc, HomeState>(
      'emits [HomeLoading, HomeLoaded] when FilterByCategory is successful',
      build: () => homeBloc,
      act: (bloc) => bloc.add(const FilterByCategory('Education')),
      expect: () => [isA<HomeLoading>(), isA<HomeLoaded>()],
    );
  });
}
 