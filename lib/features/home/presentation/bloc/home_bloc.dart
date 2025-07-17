import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/video.dart';
import '../../domain/usecases/get_videos.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final GetVideos getVideos;

  HomeBloc({required this.getVideos}) : super(HomeInitial()) {
    on<LoadVideos>(_onLoadVideos);
    on<SearchVideos>(_onSearchVideos);
    on<FilterByCategory>(_onFilterByCategory);
  }

  Future<void> _onLoadVideos(LoadVideos event, Emitter<HomeState> emit) async {
    emit(HomeLoading());

    final result = await getVideos(const GetVideosParams());

    result.fold((failure) => emit(HomeError(failure.message)), (videos) => emit(HomeLoaded(videos: videos)));
  }

  Future<void> _onSearchVideos(SearchVideos event, Emitter<HomeState> emit) async {
    emit(HomeLoading());

    final result = await getVideos(GetVideosParams(search: event.query));

    result.fold((failure) => emit(HomeError(failure.message)), (videos) => emit(HomeLoaded(videos: videos)));
  }

  Future<void> _onFilterByCategory(FilterByCategory event, Emitter<HomeState> emit) async {
    emit(HomeLoading());

    final result = await getVideos(GetVideosParams(category: event.category));

    result.fold((failure) => emit(HomeError(failure.message)), (videos) => emit(HomeLoaded(videos: videos)));
  }
}
