import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:ditonton/domain/usecases/search_tv_series.dart';
import 'package:ditonton/presentation/provider/tv_series_search_notifier.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'tv_series_search_notifier_test.mocks.dart';

@GenerateMocks([SearchTvSeries])
void main() {
  late int listenerCallCount;
  late TvSeriesSearchNotifier provider;
  late MockSearchTvSeries mockSearchTvSeries;

  setUp(() {
    listenerCallCount = 0;
    mockSearchTvSeries = MockSearchTvSeries();
    provider = TvSeriesSearchNotifier(
      searchTvSeries: mockSearchTvSeries,
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

  final testQuery = 'test';

  test('should change state to loading when usecase is called', () {
    // arrange
    when(mockSearchTvSeries.execute(testQuery)).thenAnswer(
      (_) async => Right(testTvSeriesList),
    );

    // act
    provider.fetchTvSeriesSearch(testQuery);

    // assert
    expect(provider.searchTvSeriesState, equals(RequestState.Loading));
    expect(listenerCallCount, 1);
  });

  test(
    'should change search result data when data is gotten successfully',
    () async {
      // arrange
      when(mockSearchTvSeries.execute(testQuery)).thenAnswer(
        (_) async => Right(testTvSeriesList),
      );

      // act
      await provider.fetchTvSeriesSearch(testQuery);

      // assert
      expect(provider.searchTvSeriesState, equals(RequestState.Loaded));
      expect(provider.searchResult, equals(testTvSeriesList));
      expect(listenerCallCount, 2);
    },
  );

  test('should return error when data is unsuccessful', () async {
    // arrange
    when(mockSearchTvSeries.execute(testQuery)).thenAnswer(
      (_) async => Left(ServerFailure('Server Failure')),
    );

    // act
    await provider.fetchTvSeriesSearch(testQuery);

    // assert
    expect(provider.searchTvSeriesState, equals(RequestState.Error));
    expect(provider.message, equals('Server Failure'));
    expect(listenerCallCount, 2);
  });
}
