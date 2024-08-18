import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/usecases/get_watchlist_tv_series.dart';
import 'package:ditonton/presentation/provider/watchlist_tv_series_notifier.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../dummy_data/dummy_objects.dart';
import 'watchlist_tv_series_notifier_test.mocks.dart';

@GenerateMocks([GetWatchlistTvSeries])
void main() {
  late int listenerCallCount;
  late WatchlistTvSeriesNotifier provider;
  late MockGetWatchlistTvSeries mockGetWatchlistTvSeries;

  setUp(() {
    listenerCallCount = 0;
    mockGetWatchlistTvSeries = MockGetWatchlistTvSeries();
    provider = WatchlistTvSeriesNotifier(
      getWatchlistTvSeries: mockGetWatchlistTvSeries,
    )..addListener(() => listenerCallCount += 1);
  });

  test('should change state to loading when usecase is called', () {
    // arrange
    when(mockGetWatchlistTvSeries.execute()).thenAnswer(
      (_) async => Right([testWatchtlistTvSeries]),
    );

    // act
    provider.fetchWatchlistTvSeries();

    // assert
    expect(provider.watchlistState, equals(RequestState.Loading));
  });

  test(
    'should change tv series data when data is gotten successfully',
    () async {
      // arrange
      when(mockGetWatchlistTvSeries.execute()).thenAnswer(
        (_) async => Right([testWatchtlistTvSeries]),
      );

      // act
      await provider.fetchWatchlistTvSeries();

      // assert
      expect(provider.watchlistState, equals(RequestState.Loaded));
      expect(provider.watchlistTvSeries, equals([testWatchtlistTvSeries]));
      expect(listenerCallCount, 2);
    },
  );

  test(
    'should return error when data is unsuccessful',
    () async {
      // arrange
      when(mockGetWatchlistTvSeries.execute()).thenAnswer(
        (_) async => Left(DatabaseFailure('Can\'t get data')),
      );

      // act
      await provider.fetchWatchlistTvSeries();

      // assert
      expect(provider.watchlistState, equals(RequestState.Error));
      expect(provider.message, equals('Can\'t get data'));
      expect(listenerCallCount, 2);
    },
  );
}
