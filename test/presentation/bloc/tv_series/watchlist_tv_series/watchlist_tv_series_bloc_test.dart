import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/usecases/get_watchlist_tv_series.dart';
import 'package:ditonton/domain/usecases/remove_watchlist_tv_series.dart';
import 'package:ditonton/domain/usecases/save_watchlist_tv_series.dart';
import 'package:ditonton/presentation/bloc/tv_series/watchlist_tv_series/watchlist_tv_series_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../../dummy_data/dummy_objects.dart';
import 'watchlist_tv_series_bloc_test.mocks.dart';

@GenerateMocks([
  GetWatchlistTvSeries,
  SaveWatchlistTvSeries,
  RemoveWatchlistTvSeries,
])
void main() {
  late WatchlistTvSeriesBloc watchlistTvSeriesBloc;
  late MockGetWatchlistTvSeries mockGetWatchlistTvSeries;
  late MockSaveWatchlistTvSeries mockSaveWatchlistTvSeries;
  late MockRemoveWatchlistTvSeries mockRemoveWatchlistTvSeries;

  setUp(() {
    mockRemoveWatchlistTvSeries = MockRemoveWatchlistTvSeries();
    mockSaveWatchlistTvSeries = MockSaveWatchlistTvSeries();
    mockGetWatchlistTvSeries = MockGetWatchlistTvSeries();

    watchlistTvSeriesBloc = WatchlistTvSeriesBloc(
      getWatchlistTvSeries: mockGetWatchlistTvSeries,
      saveWatchlistTvSeries: mockSaveWatchlistTvSeries,
      removeWatchlistTvSeries: mockRemoveWatchlistTvSeries,
    );
  });

  test('initial state should be WatchlistTvSeriesInitial', () {
    expect(watchlistTvSeriesBloc.state, WatchlistTvSeriesInitial());
  });

  group('Get Watchlist Tv Series', () {
    blocTest<WatchlistTvSeriesBloc, WatchlistTvSeriesState>(
      'should emit [WatchlistTvSeriesLoading, WatchlistTvSeriesHasData] when get watchlist data is successful',
      build: () {
        when(mockGetWatchlistTvSeries.execute())
            .thenAnswer((_) async => Right(testTvSeriesModelList));

        return watchlistTvSeriesBloc;
      },
      act: (bloc) => bloc.add(WatchlistTvSeriesGetEvent()),
      expect: () => <WatchlistTvSeriesState>[
        WatchlistTvSeriesLoading(),
        WatchlistTvSeriesHasData(testTvSeriesModelList),
      ],
      verify: (bloc) => mockGetWatchlistTvSeries.execute(),
    );

    blocTest<WatchlistTvSeriesBloc, WatchlistTvSeriesState>(
      'should emit [WatchlistTvSeriesLoading, WatchlistTvSeriesError] when get watchlist data is unsuccessful',
      build: () {
        when(mockGetWatchlistTvSeries.execute())
            .thenAnswer((_) async => Left(ServerFailure('Server Failure')));

        return watchlistTvSeriesBloc;
      },
      act: (bloc) => bloc.add(WatchlistTvSeriesGetEvent()),
      expect: () => <WatchlistTvSeriesState>[
        WatchlistTvSeriesLoading(),
        WatchlistTvSeriesError('Server Failure'),
      ],
      verify: (bloc) => mockGetWatchlistTvSeries.execute(),
    );
  });

  group('Save Tv Series to Watchlist', () {
    blocTest<WatchlistTvSeriesBloc, WatchlistTvSeriesState>(
      'should emit [WatchlistTvSeriesLoading, WatchlistTvSeriesSuccess] when save to watchlist is successful',
      build: () {
        when(mockSaveWatchlistTvSeries.execute(testTvSeriesDetail)).thenAnswer(
            (_) async => Right('Success add tv series to watchlist'));

        return watchlistTvSeriesBloc;
      },
      act: (bloc) => bloc.add(WatchlistTvSeriesAddEvent(testTvSeriesDetail)),
      expect: () => <WatchlistTvSeriesState>[
        WatchlistTvSeriesLoading(),
        WatchlistTvSeriesSuccess('Success add tv series to watchlist'),
      ],
      verify: (bloc) => mockSaveWatchlistTvSeries.execute(testTvSeriesDetail),
    );

    blocTest<WatchlistTvSeriesBloc, WatchlistTvSeriesState>(
      'should emit [WatchlistTvSeriesLoading, WatchlistTvSeriesError] when save to watchlist is unsuccessful',
      build: () {
        when(mockSaveWatchlistTvSeries.execute(testTvSeriesDetail))
            .thenAnswer((_) async => Left(DatabaseFailure('Database Failure')));

        return watchlistTvSeriesBloc;
      },
      act: (bloc) => bloc.add(WatchlistTvSeriesAddEvent(testTvSeriesDetail)),
      expect: () => <WatchlistTvSeriesState>[
        WatchlistTvSeriesLoading(),
        WatchlistTvSeriesError('Database Failure'),
      ],
      verify: (bloc) => mockSaveWatchlistTvSeries.execute(testTvSeriesDetail),
    );
  });

  group('Remove Tv Series from Watchlist', () {
    blocTest<WatchlistTvSeriesBloc, WatchlistTvSeriesState>(
      'should emit [WatchlistTvSeriesLoading, WatchlistTvSeriesSuccess] when remove from watchlist is successful',
      build: () {
        when(mockRemoveWatchlistTvSeries.execute(testTvSeriesDetail))
            .thenAnswer(
                (_) async => Right('Success remove tv series from watchlist'));

        return watchlistTvSeriesBloc;
      },
      act: (bloc) => bloc.add(WatchlistTvSeriesRemoveEvent(testTvSeriesDetail)),
      expect: () => <WatchlistTvSeriesState>[
        WatchlistTvSeriesLoading(),
        WatchlistTvSeriesSuccess('Success remove tv series from watchlist'),
      ],
      verify: (bloc) => mockRemoveWatchlistTvSeries.execute(testTvSeriesDetail),
    );

    blocTest<WatchlistTvSeriesBloc, WatchlistTvSeriesState>(
      'should emit [WatchlistTvSeriesLoading, WatchlistTvSeriesError] when remove from watchlist is unsuccessful',
      build: () {
        when(mockRemoveWatchlistTvSeries.execute(testTvSeriesDetail))
            .thenAnswer((_) async => Left(DatabaseFailure('Database Failure')));

        return watchlistTvSeriesBloc;
      },
      act: (bloc) => bloc.add(WatchlistTvSeriesRemoveEvent(testTvSeriesDetail)),
      expect: () => <WatchlistTvSeriesState>[
        WatchlistTvSeriesLoading(),
        WatchlistTvSeriesError('Database Failure'),
      ],
      verify: (bloc) => mockRemoveWatchlistTvSeries.execute(testTvSeriesDetail),
    );
  });
}
