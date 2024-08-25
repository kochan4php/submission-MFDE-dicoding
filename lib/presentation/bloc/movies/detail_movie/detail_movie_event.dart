part of 'detail_movie_bloc.dart';

abstract class DetailMovieEvent extends Equatable {
  const DetailMovieEvent();

  @override
  List<Object?> get props => [];
}

class DetailMovieGetEvent extends DetailMovieEvent {
  final int id;

  DetailMovieGetEvent(this.id);

  @override
  List<Object?> get props => [id];
}
