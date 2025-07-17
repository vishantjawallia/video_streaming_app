part of 'home_bloc.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object> get props => [];
}

class LoadVideos extends HomeEvent {
  const LoadVideos();
}

class SearchVideos extends HomeEvent {
  final String query;

  const SearchVideos(this.query);

  @override
  List<Object> get props => [query];
}

class FilterByCategory extends HomeEvent {
  final String category;

  const FilterByCategory(this.category);

  @override
  List<Object> get props => [category];
}
