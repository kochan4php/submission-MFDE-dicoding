part of 'watchlist_movies_bloc.dart';

abstract class WatchlistMoviesEvent extends Equatable {
  const WatchlistMoviesEvent();

  @override
  List<Object?> get props => [];
}

class WatchlistMovieGetEvent extends WatchlistMoviesEvent {}

class WatchlistMovieSaveEvent extends WatchlistMoviesEvent {
  final MovieDetail movieDetail;

  WatchlistMovieSaveEvent(this.movieDetail);

  @override
  List<Object?> get props => [movieDetail];
}

class WatchlistMovieRemoveEvent extends WatchlistMoviesEvent {
  final MovieDetail movieDetail;

  WatchlistMovieRemoveEvent(this.movieDetail);

  @override
  List<Object?> get props => [movieDetail];
}
