import 'package:ditonton/data/models/genre_model.dart';
import 'package:ditonton/data/models/tv_series_detail_model.dart';
import 'package:ditonton/domain/entities/genre.dart';
import 'package:ditonton/domain/entities/tv_series_detail.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final testTvSeriesDetailModel = TvSeriesDetailModel(
    adult: false,
    id: 1,
    originalLanguage: 'originalLanguage',
    originalName: 'originalName',
    overview: 'overview',
    popularity: 1,
    posterPath: 'posterPath',
    firstAirDate: 'firstAirDate',
    name: 'name',
    voteAverage: 1,
    voteCount: 1,
    backdropPath: 'backdropPath',
    genres: [GenreModel(id: 1, name: 'name')],
    numberOfEpisodes: 1,
    numberOfSeasons: 1,
  );

  final testTvSeriesDetail = TvSeriesDetail(
    adult: false,
    id: 1,
    originalLanguage: 'originalLanguage',
    originalName: 'originalName',
    overview: 'overview',
    posterPath: 'posterPath',
    name: 'name',
    voteAverage: 1,
    backdropPath: 'backdropPath',
    genres: [Genre(id: 1, name: 'name')],
    numberOfEpisodes: 1,
    numberOfSeasons: 1,
  );

  test('should be a subclass of TvSeriesDetail entity', () async {
    final result = testTvSeriesDetailModel.toEntity();
    expect(result, testTvSeriesDetail);
  });
}
