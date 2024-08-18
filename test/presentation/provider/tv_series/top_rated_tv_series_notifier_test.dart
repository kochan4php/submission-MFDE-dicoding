import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:ditonton/domain/usecases/get_top_rated_tv_series.dart';
import 'package:ditonton/presentation/provider/top_rated_tv_series_notifier.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'top_rated_tv_series_notifier_test.mocks.dart';

@GenerateMocks([GetTopRatedTvSeries])
void main() {
  late MockGetTopRatedTvSeries mockGetTopRatedTvSeries;
  late TopRatedTvSeriesNotifier provider;
  late int listenerCallCount;

  setUp(() {
    listenerCallCount = 0;
    mockGetTopRatedTvSeries = MockGetTopRatedTvSeries();
    provider = TopRatedTvSeriesNotifier(
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

  test('should change state to loading when usecase is called', () {
    // arrange
    when(mockGetTopRatedTvSeries.execute()).thenAnswer(
      (_) async => Right(testTvSeriesList),
    );

    // act
    provider.fetchTopRatedTvSeries();

    // assert
    expect(provider.topRatedState, equals(RequestState.Loading));
    expect(listenerCallCount, 1);
  });

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
      expect(provider.topRatedState, equals(RequestState.Loaded));
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
    expect(provider.topRatedState, equals(RequestState.Error));
    expect(provider.message, equals('Server Failure'));
    expect(listenerCallCount, 2);
  });
}
