import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/usecases/get_tv_series_detail.dart';
import 'package:ditonton/domain/usecases/get_tv_series_recommendations.dart';
import 'package:ditonton/domain/usecases/get_tv_series_watchlist_status.dart';
import 'package:ditonton/presentation/bloc/tv_series/detail_tv_series/detail_tv_series_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../../dummy_data/dummy_objects.dart';
import 'detail_tv_series_bloc_test.mocks.dart';

@GenerateMocks([
  GetTvSeriesDetail,
  GetTvSeriesRecommendations,
  GetTvSeriesWatchlistStatus,
])
void main() {
  late DetailTvSeriesBloc detailTvSeriesBloc;
  late MockGetTvSeriesDetail mockGetTvSeriesDetail;
  late MockGetTvSeriesRecommendations mockGetTvSeriesRecommendations;
  late MockGetTvSeriesWatchlistStatus mockGetTvSeriesWatchlistStatus;

  setUp(() {
    mockGetTvSeriesWatchlistStatus = MockGetTvSeriesWatchlistStatus();
    mockGetTvSeriesRecommendations = MockGetTvSeriesRecommendations();
    mockGetTvSeriesDetail = MockGetTvSeriesDetail();

    detailTvSeriesBloc = DetailTvSeriesBloc(
      getTvSeriesDetail: mockGetTvSeriesDetail,
      getTvSeriesRecommendations: mockGetTvSeriesRecommendations,
      getTvSeriesWatchlistStatus: mockGetTvSeriesWatchlistStatus,
    );
  });

  final testId = 1;

  test('initial state should be empty', () {
    expect(detailTvSeriesBloc.state, DetailTvSeriesEmpty());
  });

  blocTest<DetailTvSeriesBloc, DetailTvSeriesState>(
    'should emit [DetailTvSeriesLoading, DetailTvSeriesHasData] when data is gotten successfully',
    build: () {
      when(mockGetTvSeriesDetail.execute(testId))
          .thenAnswer((_) async => Right(testTvSeriesDetail));

      when(mockGetTvSeriesRecommendations.execute(testId))
          .thenAnswer((_) async => Right(testTvSeriesModelList));

      when(mockGetTvSeriesWatchlistStatus.execute(testId))
          .thenAnswer((_) async => true);

      return detailTvSeriesBloc;
    },
    act: (bloc) => bloc.add(DetailTvSeriesGetEvent(testId)),
    expect: () => <DetailTvSeriesState>[
      DetailTvSeriesLoading(),
      DetailTvSeriesHasData(testTvSeriesDetail, testTvSeriesModelList, true),
    ],
    verify: (bloc) => {
      verify(mockGetTvSeriesDetail.execute(testId)),
      verify(mockGetTvSeriesRecommendations.execute(testId)),
      verify(mockGetTvSeriesWatchlistStatus.execute(testId)),
    },
  );

  blocTest<DetailTvSeriesBloc, DetailTvSeriesState>(
    'should emit [DetailTvSeriesLoading, DetailTvSeriesError] when get detail data is unsuccessful',
    build: () {
      when(mockGetTvSeriesDetail.execute(testId))
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));

      when(mockGetTvSeriesRecommendations.execute(testId))
          .thenAnswer((_) async => Right(testTvSeriesModelList));

      when(mockGetTvSeriesWatchlistStatus.execute(testId))
          .thenAnswer((_) async => true);

      return detailTvSeriesBloc;
    },
    act: (bloc) => bloc.add(DetailTvSeriesGetEvent(testId)),
    expect: () => <DetailTvSeriesState>[
      DetailTvSeriesLoading(),
      DetailTvSeriesError('Server Failure'),
    ],
    verify: (bloc) => {
      verify(mockGetTvSeriesDetail.execute(testId)),
      verify(mockGetTvSeriesRecommendations.execute(testId)),
      verify(mockGetTvSeriesWatchlistStatus.execute(testId)),
    },
  );

  blocTest<DetailTvSeriesBloc, DetailTvSeriesState>(
    'should emit [DetailTvSeriesLoading, DetailTvSeriesError] when get data recommendations is unsuccessful',
    build: () {
      when(mockGetTvSeriesDetail.execute(testId))
          .thenAnswer((_) async => Right(testTvSeriesDetail));

      when(mockGetTvSeriesRecommendations.execute(testId))
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));

      when(mockGetTvSeriesWatchlistStatus.execute(testId))
          .thenAnswer((_) async => true);

      return detailTvSeriesBloc;
    },
    act: (bloc) => bloc.add(DetailTvSeriesGetEvent(testId)),
    expect: () => <DetailTvSeriesState>[
      DetailTvSeriesLoading(),
      DetailTvSeriesError('Server Failure'),
    ],
    verify: (bloc) => {
      verify(mockGetTvSeriesDetail.execute(testId)),
      verify(mockGetTvSeriesRecommendations.execute(testId)),
      verify(mockGetTvSeriesWatchlistStatus.execute(testId)),
    },
  );
}
