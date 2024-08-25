import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:ditonton/domain/usecases/get_airing_tv_series.dart';
import 'package:ditonton/presentation/bloc/tv_series/tv_series_now_airing/tv_series_now_airing_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'tv_series_now_airing_bloc_test.mocks.dart';

@GenerateMocks([GetAiringTvSeries])
void main() {
  late TvSeriesNowAiringBloc tvSeriesNowAiringBloc;
  late MockGetAiringTvSeries mockGetAiringTvSeries;

  setUp(() {
    mockGetAiringTvSeries = MockGetAiringTvSeries();
    tvSeriesNowAiringBloc = TvSeriesNowAiringBloc(
      getAiringTvSeries: mockGetAiringTvSeries,
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
    expect(tvSeriesNowAiringBloc.state, TvSeriesNowAiringEmpty());
  });

  blocTest<TvSeriesNowAiringBloc, TvSeriesNowAiringState>(
    'should emit [TvSeriesNowAiringLoading, TvSeriesNowAiringHasData] when data is gotten successfully',
    build: () {
      when(mockGetAiringTvSeries.execute())
          .thenAnswer((_) async => Right(testTvSeriesModelList));

      return tvSeriesNowAiringBloc;
    },
    act: (bloc) => bloc.add(TvSeriesNowAiringGetEvent()),
    wait: Duration(milliseconds: 500),
    expect: () => <TvSeriesNowAiringState>[
      TvSeriesNowAiringLoading(),
      TvSeriesNowAiringHasData(testTvSeriesModelList),
    ],
    verify: (bloc) => verify(mockGetAiringTvSeries.execute()),
  );

  blocTest<TvSeriesNowAiringBloc, TvSeriesNowAiringState>(
    'should emit [TvSeriesNowAiringLoading, TvSeriesNowAiringError] when get data is unsuccessful',
    build: () {
      when(mockGetAiringTvSeries.execute())
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));

      return tvSeriesNowAiringBloc;
    },
    act: (bloc) => bloc.add(TvSeriesNowAiringGetEvent()),
    wait: Duration(milliseconds: 500),
    expect: () => <TvSeriesNowAiringState>[
      TvSeriesNowAiringLoading(),
      TvSeriesNowAiringError('Server Failure'),
    ],
    verify: (bloc) => verify(mockGetAiringTvSeries.execute()),
  );
}
