import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:ditonton/domain/usecases/get_airing_tv_series.dart';
import 'package:ditonton/domain/usecases/get_popular_tv_series.dart';
import 'package:ditonton/domain/usecases/get_top_rated_tv_series.dart';
import 'package:ditonton/presentation/provider/tv_series_list_notifier.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'tv_series_list_notifier_test.mocks.dart';

@GenerateMocks([GetAiringTvSeries, GetPopularTvSeries, GetTopRatedTvSeries])
void main() {
  late TvSeriesListNotifier provider;
  late MockGetAiringTvSeries mockGetAiringTvSeries;
  late MockGetPopularTvSeries mockGetPopularTvSeries;
  late MockGetTopRatedTvSeries mockGetTopRatedTvSeries;
  late int listenerCallCount;

  setUp(() {
    listenerCallCount = 0;
    mockGetTopRatedTvSeries = MockGetTopRatedTvSeries();
    mockGetPopularTvSeries = MockGetPopularTvSeries();
    mockGetAiringTvSeries = MockGetAiringTvSeries();

    provider = TvSeriesListNotifier(
      getAiringTvSeries: mockGetAiringTvSeries,
      getPopularTvSeries: mockGetPopularTvSeries,
      getTopRatedTvSeries: mockGetTopRatedTvSeries,
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

  group('Airing Tv Series', () {
    test('initialState should be Empty', () {
      expect(provider.nowAiringState, equals(RequestState.Empty));
    });

    test('should get data from the usecase', () async {
      // arrange
      when(mockGetAiringTvSeries.execute()).thenAnswer(
        (_) async => Right(testTvSeriesList),
      );

      // act
      provider.fetchNowAiringTvSeries();

      // assert
      verify(mockGetAiringTvSeries.execute());
    });

    test('should change state to Loading when usecase is called', () {
      // arrange
      when(mockGetAiringTvSeries.execute()).thenAnswer(
        (_) async => Right(testTvSeriesList),
      );

      // act
      provider.fetchNowAiringTvSeries();

      // assert
      expect(provider.nowAiringState, equals(RequestState.Loading));
    });

    test(
      'should change tv series data when data is gotten successful',
      () async {
        // arrange
        when(mockGetAiringTvSeries.execute()).thenAnswer(
          (_) async => Right(testTvSeriesList),
        );

        // act
        await provider.fetchNowAiringTvSeries();

        // assert
        expect(provider.nowAiringState, equals(RequestState.Loaded));
        expect(provider.nowAiringTvSeries, equals(testTvSeriesList));
        expect(listenerCallCount, 2);
      },
    );

    test(
      'should return error when data is unsuccessful',
      () async {
        // arrange
        when(mockGetAiringTvSeries.execute()).thenAnswer(
          (_) async => Left(ServerFailure('Server Failure')),
        );

        // act
        await provider.fetchNowAiringTvSeries();

        // assert
        expect(provider.nowAiringState, equals(RequestState.Error));
        expect(provider.message, 'Server Failure');
        expect(listenerCallCount, 2);
      },
    );
  });

  group('Top Rated Tv Series', () {
    test(
      'should change state to loading when usecase is called',
      () async {
        // arrange
        when(mockGetTopRatedTvSeries.execute()).thenAnswer(
          (_) async => Right(testTvSeriesList),
        );

        // act
        provider.fetchTopRatedTvSeries();

        // assert
        expect(provider.topRatedTvSeriesState, equals(RequestState.Loading));
      },
    );

    test(
      'should change tv series data when data is gotten successfully',
      () async {
        // arrange
        when(mockGetTopRatedTvSeries.execute()).thenAnswer(
          (_) async => Right(testTvSeriesList),
        );

        // act
        await provider.fetchTopRatedTvSeries();

        // assert
        expect(provider.topRatedTvSeriesState, equals(RequestState.Loaded));
        expect(provider.topRatedTvSeries, equals(testTvSeriesList));
        expect(listenerCallCount, 2);
      },
    );

    test('should return error when data is unsuccessful', () async {
      // arrange
      when(mockGetTopRatedTvSeries.execute()).thenAnswer(
        (_) async => Left(ServerFailure('Server Failure')),
      );

      // act
      await provider.fetchTopRatedTvSeries();

      // assert
      expect(provider.topRatedTvSeriesState, equals(RequestState.Error));
      expect(provider.message, equals('Server Failure'));
      expect(listenerCallCount, 2);
    });

    group('Popular Tv Series', () {
      test('should change state to loading when usecase is called', () {
        // arrange
        when(mockGetPopularTvSeries.execute()).thenAnswer(
          (_) async => Right(testTvSeriesList),
        );

        // act
        provider.fetchPopularTvSeries();

        // assert
        expect(provider.popularTvSeriesState, equals(RequestState.Loading));
      });

      test(
        'should change tv series data when data is gotten successfully',
        () async {
          // arrange
          when(mockGetPopularTvSeries.execute()).thenAnswer(
            (_) async => Right(testTvSeriesList),
          );

          // act
          await provider.fetchPopularTvSeries();

          // assert
          expect(provider.popularTvSeriesState, equals(RequestState.Loaded));
          expect(provider.popularTvSeries, equals(testTvSeriesList));
          expect(listenerCallCount, 2);
        },
      );

      test('should return error when data is unsuccessful', () async {
        // arrange
        when(mockGetPopularTvSeries.execute()).thenAnswer(
          (_) async => Left(ServerFailure('Server Failure')),
        );

        // act
        await provider.fetchPopularTvSeries();

        // assert
        expect(provider.popularTvSeriesState, equals(RequestState.Error));
        expect(provider.message, equals('Server Failure'));
        expect(listenerCallCount, 2);
      });
    });
  });
}
