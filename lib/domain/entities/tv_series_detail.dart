import 'package:ditonton/domain/entities/genre.dart';
import 'package:equatable/equatable.dart';

class TvSeriesDetail extends Equatable {
  final int id;
  final String name;
  final bool adult;
  final String backdropPath;
  final List<Genre> genres;
  final String originalLanguage;
  final String originalName;
  final String overview;
  final String posterPath;
  final int numberOfEpisodes;
  final int numberOfSeasons;
  final double voteAverage;

  TvSeriesDetail({
    required this.id,
    required this.name,
    required this.adult,
    required this.backdropPath,
    required this.genres,
    required this.originalLanguage,
    required this.originalName,
    required this.overview,
    required this.posterPath,
    required this.numberOfEpisodes,
    required this.numberOfSeasons,
    required this.voteAverage,
  });

  @override
  List<Object?> get props => [];
}
