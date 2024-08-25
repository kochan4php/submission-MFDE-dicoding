import 'package:ditonton/data/models/movie_table.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final testMovieTable = MovieTable(
    id: 1,
    overview: 'overview',
    posterPath: 'posterPath',
    title: 'title',
  );

  final testMovieEntity = Movie.watchlist(
    id: 1,
    overview: 'overview',
    posterPath: 'posterPath',
    title: 'title',
  );

  test('should be a subclass of Movie Watchlist entity', () async {
    final result = testMovieTable.toEntity();
    expect(result, testMovieEntity);
  });
}
