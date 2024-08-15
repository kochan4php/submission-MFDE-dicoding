import 'package:ditonton/data/models/genre_model.dart';
import 'package:ditonton/domain/entities/tv_series_detail.dart';
import 'package:equatable/equatable.dart';

class TvSeriesDetailModel extends Equatable {
  final bool adult;
  final String? backdropPath;
  final List<GenreModel> genres;
  final int id;
  final String originalLanguage;
  final String originalName;
  final String overview;
  final String popularity;
  final String posterPath;
  final String firstAirDate;
  final String name;
  final double voteAverage;
  final int voteCount;
  final int numberOfSeasons;
  final int numberOfEpisodes;

  TvSeriesDetailModel({
    required this.adult,
    required this.backdropPath,
    required this.genres,
    required this.id,
    required this.originalLanguage,
    required this.originalName,
    required this.overview,
    required this.popularity,
    required this.posterPath,
    required this.firstAirDate,
    required this.name,
    required this.voteAverage,
    required this.voteCount,
    required this.numberOfEpisodes,
    required this.numberOfSeasons,
  });

  factory TvSeriesDetailModel.fromJson(Map<String, dynamic> json) {
    return TvSeriesDetailModel(
      adult: json['adult'],
      backdropPath: json['backdrop_path'],
      genres: List<GenreModel>.from(
        (json['genres'] as List).map((x) => GenreModel.fromJson(x)),
      ),
      id: json['id'],
      originalLanguage: json['original_language'],
      originalName: json['original_name'],
      overview: json['overview'],
      popularity: json['popularity'],
      posterPath: json['poster_path'],
      firstAirDate: json['first_air_date'],
      name: json['name'],
      voteAverage: json['vote_average'],
      voteCount: json['vote_count'],
      numberOfEpisodes: json['number_of_episodes'],
      numberOfSeasons: json['number_of_seasons'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'adult': adult,
      'backdropPath': backdropPath,
      'genres': genres.map((x) => x.toJson()).toList(),
      'id': id,
      'originalLanguage': originalLanguage,
      'originalName': originalName,
      'overview': overview,
      'popularity': popularity,
      'posterPath': posterPath,
      'firstAirDate': firstAirDate,
      'name': name,
      'voteAverage': voteAverage,
      'voteCount': voteCount,
      'numberOfEpisodes': numberOfEpisodes,
      'numberOfSeasons': numberOfSeasons,
    };
  }

  TvSeriesDetail toEntity() {
    return TvSeriesDetail(
      id: this.id,
      name: this.name,
      adult: this.adult,
      backdropPath: this.backdropPath!,
      genres: this.genres.map((genre) => genre.toEntity()).toList(),
      originalLanguage: this.originalLanguage,
      originalName: this.originalName,
      overview: this.overview,
      posterPath: this.posterPath,
      numberOfEpisodes: this.numberOfEpisodes,
      numberOfSeasons: this.numberOfSeasons,
      voteAverage: this.voteAverage,
    );
  }

  @override
  List<Object?> get props => [
        adult,
        backdropPath,
        genres,
        id,
        originalLanguage,
        originalName,
        overview,
        popularity,
        posterPath,
        firstAirDate,
        name,
        voteAverage,
        voteCount,
        numberOfEpisodes,
        numberOfSeasons,
      ];
}
