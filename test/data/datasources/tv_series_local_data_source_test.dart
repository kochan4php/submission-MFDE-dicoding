import 'package:ditonton/common/exception.dart';
import 'package:ditonton/data/datasources/tv_series_local_data_source.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late TvSeriesLocalDataSourceImpl dataSource;
  late MockDatabaseHelper mockDatabaseHelper;

  setUp(() {
    mockDatabaseHelper = MockDatabaseHelper();
    dataSource = TvSeriesLocalDataSourceImpl(
      databaseHelper: mockDatabaseHelper,
    );
  });

  group('Save watchlist tv series', () {
    test(
      'should return success message when insert tv series to database is success',
      () async {
        // arrange
        when(mockDatabaseHelper.insertTvSeriesWatchlist(testTvSeriesTable))
            .thenAnswer((_) async => 1);

        // act
        final result = await dataSource.insertWatchlist(testTvSeriesTable);

        // assert
        verify(mockDatabaseHelper.insertTvSeriesWatchlist(testTvSeriesTable));
        expect(result, 'Added tv series to watchlist');
      },
    );

    test(
      'should throw DatabaseException when insert tv series to database is failed',
      () async {
        // arrange
        when(mockDatabaseHelper.insertTvSeriesWatchlist(testTvSeriesTable))
            .thenThrow(Exception());

        // act
        final call = dataSource.insertWatchlist(testTvSeriesTable);

        // assert
        expect(() => call, throwsA(isA<DatabaseException>()));
      },
    );
  });

  group('Remove watchlist tv series', () {
    test(
      'should return success message when delete tv series to database is success',
      () async {
        // arrange
        when(mockDatabaseHelper.removeTvSeriesWatchlist(testTvSeriesTable))
            .thenAnswer((_) async => 1);

        // act
        final result = await dataSource.removeWatchlist(testTvSeriesTable);

        // assert
        verify(mockDatabaseHelper.removeTvSeriesWatchlist(testTvSeriesTable));
        expect(result, 'Remove tv series from watchlist');
      },
    );

    test(
      'should throw DatabaseException when delete tv series to database is failed',
      () async {
        // arrange
        when(mockDatabaseHelper.removeTvSeriesWatchlist(testTvSeriesTable))
            .thenThrow(Exception());

        // act
        final call = dataSource.removeWatchlist(testTvSeriesTable);

        // assert
        expect(() => call, throwsA(isA<DatabaseException>()));
      },
    );
  });

  group('Get TvSeries detail by id', () {
    final testId = 1;

    test('should return TvSeries Detail Table when data is found', () async {
      // arrange
      when(mockDatabaseHelper.getTvSeriesById(testId))
          .thenAnswer((_) async => testTvSeriesMap);

      // act
      final result = await dataSource.getTvSeriesDetail(testId);

      // assert
      expect(result, testTvSeriesTable);
    });

    test('should return null when data is not found', () async {
      // arrange
      when(mockDatabaseHelper.getTvSeriesById(testId))
          .thenAnswer((_) async => null);

      // act
      final result = await dataSource.getTvSeriesDetail(testId);

      // assert
      expect(result, null);
    });
  });

  group('get watchlist tv series', () {
    test('should return list of TvSeriesTable from database', () async {
      // arrange
      when(mockDatabaseHelper.getWatchlistTvSeries()).thenAnswer(
        (_) async => [testTvSeriesMap],
      );

      // act
      final result = await dataSource.getWatchlistTvSeries();

      // assert
      verify(mockDatabaseHelper.getWatchlistTvSeries());
      expect(result, [testTvSeriesTable]);
    });
  });
}
