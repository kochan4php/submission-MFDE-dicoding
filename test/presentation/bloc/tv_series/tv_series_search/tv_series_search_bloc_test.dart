import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:ditonton/domain/usecases/search_tv_series.dart';
import 'package:ditonton/presentation/bloc/tv_series/tv_series_search/tv_series_search_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'tv_series_search_bloc_test.mocks.dart';

@GenerateMocks([SearchTvSeries])
void main() {
  late TvSeriesSearchBloc tvSeriesSearchBloc;
  late MockSearchTvSeries mockSearchTvSeries;

  setUp(() {
    mockSearchTvSeries = MockSearchTvSeries();
    tvSeriesSearchBloc = TvSeriesSearchBloc(searchTvSeries: mockSearchTvSeries);
  });

  final testTvSeriesModel = TvSeries(
    adult: false,
    genreIds: [1],
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

  final testTvSeriesModelList = [testTvSeriesModel];
  final testQuery = 'query';

  test('initial state should be empty', () {
    expect(tvSeriesSearchBloc.state, TvSeriesSearchEmpty());
  });

  blocTest<TvSeriesSearchBloc, TvSeriesSearchState>(
    'should emit [TvSeriesSearchLoading, TvSeriesSearchHasData] when data is gotten successfully',
    build: () {
      when(mockSearchTvSeries.execute(testQuery))
          .thenAnswer((_) async => Right(testTvSeriesModelList));

      return tvSeriesSearchBloc;
    },
    act: (bloc) => bloc.add(OnTvSeriesQueryChanged(testQuery)),
    wait: Duration(milliseconds: 500),
    expect: () => <TvSeriesSearchState>[
      TvSeriesSearchLoading(),
      TvSeriesSearchHasData(testTvSeriesModelList),
    ],
    verify: (bloc) => verify(mockSearchTvSeries.execute(testQuery)),
  );

  blocTest<TvSeriesSearchBloc, TvSeriesSearchState>(
    'should emit [TvSeriesSearchLoading, TvSeriesSearchError] when get search data is unsuccessful',
    build: () {
      when(mockSearchTvSeries.execute(testQuery))
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));

      return tvSeriesSearchBloc;
    },
    act: (bloc) => bloc.add(OnTvSeriesQueryChanged(testQuery)),
    wait: Duration(milliseconds: 500),
    expect: () => <TvSeriesSearchState>[
      TvSeriesSearchLoading(),
      TvSeriesSearchError('Server Failure'),
    ],
    verify: (bloc) => verify(mockSearchTvSeries.execute(testQuery)),
  );
}
