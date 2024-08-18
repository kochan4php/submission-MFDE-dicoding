import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:ditonton/domain/usecases/get_popular_tv_series.dart';
import 'package:ditonton/presentation/provider/popular_tv_series_notifier.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'popular_tv_series_list_notifier_test.mocks.dart';

@GenerateMocks([GetPopularTvSeries])
void main() {
  late PopularTvSeriesNotifier provider;
  late MockGetPopularTvSeries mockGetPopularTvSeries;
  late int listenerCallCount;

  setUp(() {
    mockGetPopularTvSeries = MockGetPopularTvSeries();
    listenerCallCount = 0;
    provider = PopularTvSeriesNotifier(
      getPopularTvSeries: mockGetPopularTvSeries,
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

  test('should change state to loading when usecase is called', () {
    // arrange
    when(mockGetPopularTvSeries.execute()).thenAnswer(
      (_) async => Right(testTvSeriesList),
    );

    // act
    provider.fetchPopularTvSeries();

    // assert
    expect(provider.popularTvSeriesState, equals(RequestState.Loading));
    expect(listenerCallCount, 1);
  });

  test(
    'should change tv series data when data is gotten successful',
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

  test(
    'should return error when data is unsuccessful',
    () async {
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
    },
  );
}
