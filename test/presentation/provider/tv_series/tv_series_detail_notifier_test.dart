import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:ditonton/domain/usecases/get_tv_series_detail.dart';
import 'package:ditonton/domain/usecases/get_tv_series_recommendations.dart';
import 'package:ditonton/domain/usecases/get_tv_series_watchlist_status.dart';
import 'package:ditonton/domain/usecases/remove_watchlist_tv_series.dart';
import 'package:ditonton/domain/usecases/save_watchlist_tv_series.dart';
import 'package:ditonton/presentation/provider/tv_series_detail_notifier.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../dummy_data/dummy_objects.dart';
import 'tv_series_detail_notifier_test.mocks.dart';

@GenerateMocks([
  GetTvSeriesDetail,
  GetTvSeriesRecommendations,
  SaveWatchlistTvSeries,
  RemoveWatchlistTvSeries,
  GetTvSeriesWatchlistStatus,
])
void main() {
  late int listenerCallCount;
  late TvSeriesDetailNotifier provider;
  late MockGetTvSeriesDetail mockGetTvSeriesDetail;
  late MockGetTvSeriesRecommendations mockGetTvSeriesRecommendations;
  late MockSaveWatchlistTvSeries mockSaveWatchlistTvSeries;
  late MockRemoveWatchlistTvSeries mockRemoveWatchlistTvSeries;
  late MockGetTvSeriesWatchlistStatus mockGetTvSeriesWatchlistStatus;

  setUp(() {
    listenerCallCount = 0;
    mockGetTvSeriesWatchlistStatus = MockGetTvSeriesWatchlistStatus();
    mockRemoveWatchlistTvSeries = MockRemoveWatchlistTvSeries();
    mockSaveWatchlistTvSeries = MockSaveWatchlistTvSeries();
    mockGetTvSeriesRecommendations = MockGetTvSeriesRecommendations();
    mockGetTvSeriesDetail = MockGetTvSeriesDetail();
    provider = TvSeriesDetailNotifier(
      getTvSeriesDetail: mockGetTvSeriesDetail,
      getTvSeriesRecommendations: mockGetTvSeriesRecommendations,
      saveWatchlistTvSeries: mockSaveWatchlistTvSeries,
      removeWatchlistTvSeries: mockRemoveWatchlistTvSeries,
      getTvSeriesWatchlistStatus: mockGetTvSeriesWatchlistStatus,
    )..addListener(() => listenerCallCount += 1);
  });

  final TvSeries testTvSeries = TvSeries(
    adult: false,
    genreIds: [1, 2, 3],
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
  );

  final List<TvSeries> testTvSeriesList = [testTvSeries];

  final testId = 1;

  void _arrangeUseCase() {
    when(mockGetTvSeriesDetail.execute(testId)).thenAnswer(
      (_) async => Right(testTvSeriesDetail),
    );

    when(mockGetTvSeriesRecommendations.execute(testId)).thenAnswer(
      (_) async => Right(testTvSeriesList),
    );
  }

  group('Get Tv Series Detail', () {
    test('should get data from the usecase', () async {
      // arrange
      _arrangeUseCase();

      // act
      await provider.fetchTvSeriesDetail(testId);

      // assert
      verify(mockGetTvSeriesDetail.execute(testId));
      verify(mockGetTvSeriesRecommendations.execute(testId));
    });

    test('should change state to Loading when usecase is called', () {
      // arrange
      _arrangeUseCase();

      // act
      provider.fetchTvSeriesDetail(testId);

      // assert
      expect(provider.tvSeriesState, RequestState.Loading);
      expect(listenerCallCount, 1);
    });

    test('should change movie when data is gotten successfully', () async {
      // arrange
      _arrangeUseCase();

      // act
      await provider.fetchTvSeriesDetail(testId);

      // assert
      expect(provider.tvSeriesState, RequestState.Loaded);
      expect(provider.tvSeriesDetail, testTvSeriesDetail);
      expect(listenerCallCount, 3);
    });

    test(
      'should change recommendation movies when data is gotten successfully',
      () async {
        // arrange
        _arrangeUseCase();

        // act
        await provider.fetchTvSeriesDetail(testId);

        // assert
        expect(provider.tvSeriesState, RequestState.Loaded);
        expect(provider.tvSeriesRecommendation, testTvSeriesList);
      },
    );
  });

  group('Get Tv Series Recommendations', () {
    test('should get data from the usecase', () async {
      // arrange
      _arrangeUseCase();

      // act
      await provider.fetchTvSeriesDetail(testId);

      // assert
      verify(mockGetTvSeriesRecommendations.execute(testId));
      expect(provider.tvSeriesRecommendation, testTvSeriesList);
    });

    test(
      'should update recommendation state when data is gotten successfully',
      () async {
        // arrange
        _arrangeUseCase();

        // act
        await provider.fetchTvSeriesDetail(testId);

        // assert
        expect(provider.recommendationState, RequestState.Loaded);
        expect(provider.tvSeriesRecommendation, testTvSeriesList);
      },
    );

    test('should update error message when request in successful', () async {
      // arrange
      when(mockGetTvSeriesDetail.execute(testId)).thenAnswer(
        (_) async => Right(testTvSeriesDetail),
      );

      when(mockGetTvSeriesRecommendations.execute(testId)).thenAnswer(
        (_) async => Left(ServerFailure('Failed')),
      );

      // act
      await provider.fetchTvSeriesDetail(testId);

      // assert
      expect(provider.recommendationState, RequestState.Error);
      expect(provider.message, 'Failed');
    });
  });

  group('Watchlist Tv Series', () {
    test('should get the watchlist status', () async {
      // arrange
      when(mockGetTvSeriesWatchlistStatus.execute(1)).thenAnswer(
        (_) async => true,
      );

      // act
      await provider.loadTvSeriesWatchlistStatus(1);

      // assert
      expect(provider.isAddedToWatchlist, true);
    });

    test('should execute save watchlist when function called', () async {
      // arrange
      when(mockSaveWatchlistTvSeries.execute(testTvSeriesDetail))
          .thenAnswer((_) async => Right('Success'));

      when(mockGetTvSeriesWatchlistStatus.execute(testTvSeriesDetail.id))
          .thenAnswer((_) async => true);

      // act
      await provider.addWatchlist(testTvSeriesDetail);

      // assert
      verify(mockSaveWatchlistTvSeries.execute(testTvSeriesDetail));
    });

    test('should execute remove watchlist when function called', () async {
      // arrange
      when(mockRemoveWatchlistTvSeries.execute(testTvSeriesDetail))
          .thenAnswer((_) async => Right('Removed'));

      when(mockGetTvSeriesWatchlistStatus.execute(testTvSeriesDetail.id))
          .thenAnswer((_) async => false);

      // act
      await provider.removeWatchlist(testTvSeriesDetail);

      // assert
      verify(mockRemoveWatchlistTvSeries.execute(testTvSeriesDetail));
    });

    test('should update watchlist status when add watchlist success', () async {
      // arrange
      when(mockSaveWatchlistTvSeries.execute(testTvSeriesDetail))
          .thenAnswer((_) async => Right('Added tv series to watchlist'));

      when(mockGetTvSeriesWatchlistStatus.execute(testMovieDetail.id))
          .thenAnswer((_) async => true);

      // act
      await provider.addWatchlist(testTvSeriesDetail);

      // assert
      verify(mockGetTvSeriesWatchlistStatus.execute(testTvSeriesDetail.id));
      expect(provider.isAddedToWatchlist, true);
      expect(provider.watchlistMessage, 'Added tv series to watchlist');
      expect(listenerCallCount, 1);
    });

    test('should update watchlist message when add watchlist failed', () async {
      // arrange
      when(mockSaveWatchlistTvSeries.execute(testTvSeriesDetail))
          .thenAnswer((_) async => Left(DatabaseFailure('Failed')));

      when(mockGetTvSeriesWatchlistStatus.execute(testTvSeriesDetail.id))
          .thenAnswer((_) async => false);

      // act
      await provider.addWatchlist(testTvSeriesDetail);

      // assert
      expect(provider.watchlistMessage, 'Failed');
      expect(listenerCallCount, 1);
    });
  });

  group('on Error', () {
    test('should return error when data is unsuccessful', () async {
      // arrange
      when(mockGetTvSeriesDetail.execute(testId))
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));

      when(mockGetTvSeriesRecommendations.execute(testId))
          .thenAnswer((_) async => Right(testTvSeriesList));

      // act
      await provider.fetchTvSeriesDetail(testId);

      // assert
      expect(provider.tvSeriesState, RequestState.Error);
      expect(provider.message, 'Server Failure');
      expect(listenerCallCount, 2);
    });
  });
}
