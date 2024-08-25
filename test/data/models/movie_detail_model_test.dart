import 'package:ditonton/data/models/genre_model.dart';
import 'package:ditonton/data/models/movie_detail_model.dart';
import 'package:ditonton/domain/entities/genre.dart';
import 'package:ditonton/domain/entities/movie_detail.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final testMovieDetailModel = MovieDetailResponse(
    adult: false,
    backdropPath: 'backdropPath',
    id: 1,
    originalTitle: 'originalTitle',
    overview: 'overview',
    popularity: 1,
    posterPath: 'posterPath',
    releaseDate: 'releaseDate',
    title: 'title',
    video: false,
    voteAverage: 1,
    voteCount: 1,
    budget: 1,
    genres: [GenreModel(id: 1, name: 'name')],
    homepage: 'homepage',
    imdbId: '1',
    originalLanguage: 'originalLanguage',
    revenue: 1,
    runtime: 1,
    status: 'status',
    tagline: 'tagline',
  );

  final testMovieDetail = MovieDetail(
    adult: false,
    backdropPath: 'backdropPath',
    id: 1,
    originalTitle: 'originalTitle',
    overview: 'overview',
    posterPath: 'posterPath',
    releaseDate: 'releaseDate',
    title: 'title',
    voteAverage: 1,
    voteCount: 1,
    genres: [Genre(id: 1, name: 'name')],
    runtime: 1,
  );

  test('should be a subclass of MovieDetail entity', () async {
    final result = testMovieDetailModel.toEntity();
    expect(result, testMovieDetail);
  });
}
