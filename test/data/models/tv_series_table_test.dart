import 'package:ditonton/data/models/tv_series_table.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final testTvSeriesTable = TvSeriesTable(
    id: 1,
    overview: 'overview',
    posterPath: 'posterPath',
    name: 'name',
  );

  final testTvSeriesEntity = TvSeries.watchList(
    id: 1,
    overview: 'overview',
    posterPath: 'posterPath',
    name: 'name',
  );

  test('should be a subclass of TvSeries Watchlist entity', () async {
    final result = testTvSeriesTable.toEntity();
    expect(result, testTvSeriesEntity);
  });
}
