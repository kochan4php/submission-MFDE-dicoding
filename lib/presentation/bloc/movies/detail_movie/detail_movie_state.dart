part of 'detail_movie_bloc.dart';

abstract class DetailMovieState extends Equatable {
  const DetailMovieState();

  @override
  List<Object?> get props => [];
}

class DetailMovieEmpty extends DetailMovieState {}

class DetailMovieLoading extends DetailMovieState {}

class DetailMovieHasData extends DetailMovieState {
  final MovieDetail movieDetail;
  final List<Movie> moviesRecommendations;
  final bool isAddedToWatchlist;

  DetailMovieHasData(
    this.movieDetail,
    this.moviesRecommendations,
    this.isAddedToWatchlist,
  );

  @override
  List<Object?> get props => [movieDetail];
}

class DetailMovieError extends DetailMovieState {
  final String message;

  DetailMovieError(this.message);

  @override
  List<Object?> get props => [message];
}
