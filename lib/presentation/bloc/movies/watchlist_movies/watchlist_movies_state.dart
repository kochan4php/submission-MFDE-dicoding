part of 'watchlist_movies_bloc.dart';

abstract class WatchlistMoviesState extends Equatable {
  const WatchlistMoviesState();

  @override
  List<Object> get props => [];
}

class WatchlistMoviesInitial extends WatchlistMoviesState {}

class WatchlistMoviesLoading extends WatchlistMoviesState {}

class WatchlistMoviesHasData extends WatchlistMoviesState {
  final List<Movie> movies;

  WatchlistMoviesHasData(this.movies);

  @override
  List<Object> get props => [movies];
}

class WatchlistMoviesSuccess extends WatchlistMoviesState {
  final String message;

  WatchlistMoviesSuccess(this.message);

  @override
  List<Object> get props => [message];
}

class WatchlistMoviesError extends WatchlistMoviesState {
  final String message;

  WatchlistMoviesError(this.message);

  @override
  List<Object> get props => [message];
}
