import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:ditonton/domain/usecases/get_top_rated_tv_series.dart';
import 'package:ditonton/presentation/bloc/tv_series/top_rated_tv_series/top_rated_tv_series_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'top_rated_tv_series_bloc_test.mocks.dart';

@GenerateMocks([GetTopRatedTvSeries])
void main() {
  late TopRatedTvSeriesBloc topRatedTvSeriesBloc;
  late MockGetTopRatedTvSeries mockGetTopRatedTvSeries;

  setUp(() {
    mockGetTopRatedTvSeries = MockGetTopRatedTvSeries();
    topRatedTvSeriesBloc = TopRatedTvSeriesBloc(
      getTopRatedTvSeries: mockGetTopRatedTvSeries,
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
    expect(topRatedTvSeriesBloc.state, TopRatedTvSeriesEmpty());
  });

  blocTest<TopRatedTvSeriesBloc, TopRatedTvSeriesState>(
    'should emit [TopRatedTvSeriesLoading, TopRatedTvSeriesHasData] when data is gotten successfully',
    build: () {
      when(mockGetTopRatedTvSeries.execute())
          .thenAnswer((_) async => Right(testTvSeriesModelList));

      return topRatedTvSeriesBloc;
    },
    act: (bloc) => bloc.add(TopRatedTvSeriesGetEvent()),
    wait: Duration(milliseconds: 500),
    expect: () => <TopRatedTvSeriesState>[
      TopRatedTvSeriesLoading(),
      TopRatedTvSeriesHasData(testTvSeriesModelList),
    ],
    verify: (bloc) => verify(mockGetTopRatedTvSeries.execute()),
  );

  blocTest<TopRatedTvSeriesBloc, TopRatedTvSeriesState>(
    'should emit [TopRatedTvSeriesLoading, TopRatedTvSeriesError] when get data is unsuccessful',
    build: () {
      when(mockGetTopRatedTvSeries.execute())
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));

      return topRatedTvSeriesBloc;
    },
    act: (bloc) => bloc.add(TopRatedTvSeriesGetEvent()),
    wait: Duration(milliseconds: 500),
    expect: () => <TopRatedTvSeriesState>[
      TopRatedTvSeriesLoading(),
      TopRatedTvSeriesError('Server Failure'),
    ],
    verify: (bloc) => verify(mockGetTopRatedTvSeries.execute()),
  );
}
