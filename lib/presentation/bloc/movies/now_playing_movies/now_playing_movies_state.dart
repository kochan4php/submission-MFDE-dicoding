part of 'now_playing_movies_bloc.dart';

abstract class NowPlayingMoviesState extends Equatable {
  const NowPlayingMoviesState();

  @override
  List<Object> get props => [];
}

class NowPlayingMoviesEmpty extends NowPlayingMoviesState {}

class NowPlayingMoviesLoading extends NowPlayingMoviesState {}

class NowPlayingMoviesHasData extends NowPlayingMoviesState {
  final List<Movie> movies;

  NowPlayingMoviesHasData(this.movies);

  @override
  List<Object> get props => [movies];
}

class NowPlayingMoviesError extends NowPlayingMoviesState {
  final String message;

  NowPlayingMoviesError(this.message);

  @override
  List<Object> get props => [message];
}
