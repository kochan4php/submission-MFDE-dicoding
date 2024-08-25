import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:ditonton/domain/usecases/get_popular_tv_series.dart';
import 'package:ditonton/presentation/bloc/tv_series/popular_tv_series/popular_tv_series_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'popular_tv_series_bloc_test.mocks.dart';

@GenerateMocks([GetPopularTvSeries])
void main() {
  late PopularTvSeriesBloc popularTvSeriesBloc;
  late MockGetPopularTvSeries mockGetPopularTvSeries;

  setUp(() {
    mockGetPopularTvSeries = MockGetPopularTvSeries();
    popularTvSeriesBloc = PopularTvSeriesBloc(
      getPopularTvSeries: mockGetPopularTvSeries,
    );
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

  test('initial state should be empty', () {
    expect(popularTvSeriesBloc.state, PopularTvSeriesEmpty());
  });

  blocTest<PopularTvSeriesBloc, PopularTvSeriesState>(
    'should emit [PopularTvSeriesLoading, PopularTvSeriesHasData] when data is gotten successfully',
    build: () {
      when(mockGetPopularTvSeries.execute())
          .thenAnswer((_) async => Right(testTvSeriesModelList));

      return popularTvSeriesBloc;
    },
    act: (bloc) => bloc.add(PopularTvSeriesGetEvent()),
    wait: Duration(milliseconds: 500),
    expect: () => <PopularTvSeriesState>[
      PopularTvSeriesLoading(),
      PopularTvSeriesHasData(testTvSeriesModelList),
    ],
    verify: (bloc) => verify(mockGetPopularTvSeries.execute()),
  );

  blocTest<PopularTvSeriesBloc, PopularTvSeriesState>(
    'should emit [PopularTvSeriesLoading, PopularTvSeriesError] when get data is unsuccessful',
    build: () {
      when(mockGetPopularTvSeries.execute())
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));

      return popularTvSeriesBloc;
    },
    act: (bloc) => bloc.add(PopularTvSeriesGetEvent()),
    wait: Duration(milliseconds: 500),
    expect: () => <PopularTvSeriesState>[
      PopularTvSeriesLoading(),
      PopularTvSeriesError('Server Failure'),
    ],
    verify: (bloc) => verify(mockGetPopularTvSeries.execute()),
  );
}
