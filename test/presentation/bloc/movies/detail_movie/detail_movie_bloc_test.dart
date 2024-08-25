import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/usecases/get_movie_detail.dart';
import 'package:ditonton/domain/usecases/get_movie_recommendations.dart';
import 'package:ditonton/domain/usecases/get_watchlist_status.dart';
import 'package:ditonton/presentation/bloc/movies/detail_movie/detail_movie_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../../dummy_data/dummy_objects.dart';
import 'detail_movie_bloc_test.mocks.dart';

@GenerateMocks([
  GetMovieDetail,
  GetMovieRecommendations,
  GetWatchListStatus,
])
void main() {
  late DetailMovieBloc detailMovieBloc;
  late MockGetMovieDetail mockGetMovieDetail;
  late MockGetMovieRecommendations mockGetMovieRecommendations;
  late MockGetWatchListStatus mockGetWatchListStatus;

  setUp(() {
    mockGetMovieDetail = MockGetMovieDetail();
    mockGetMovieRecommendations = MockGetMovieRecommendations();
    mockGetWatchListStatus = MockGetWatchListStatus();

    detailMovieBloc = DetailMovieBloc(
      getMovieDetail: mockGetMovieDetail,
      getMovieRecommendations: mockGetMovieRecommendations,
      getWatchListStatus: mockGetWatchListStatus,
    );
  });

  final testId = 1;

  test('initial state should be empty', () {
    expect(detailMovieBloc.state, DetailMovieEmpty());
  });

  blocTest<DetailMovieBloc, DetailMovieState>(
    'should emit [DetailMovieLoading, DetailMovieHasData] when data is gotten successfully',
    build: () {
      when(mockGetMovieDetail.execute(testId))
          .thenAnswer((_) async => Right(testMovieDetail));

      when(mockGetMovieRecommendations.execute(testId))
          .thenAnswer((_) async => Right(testMovieList));

      when(mockGetWatchListStatus.execute(testId))
          .thenAnswer((_) async => true);

      return detailMovieBloc;
    },
    act: (bloc) => bloc.add(DetailMovieGetEvent(testId)),
    expect: () => <DetailMovieState>[
      DetailMovieLoading(),
      DetailMovieHasData(testMovieDetail, testMovieList, true),
    ],
    verify: (bloc) => {
      verify(mockGetMovieDetail.execute(testId)),
      verify(mockGetMovieRecommendations.execute(testId)),
      verify(mockGetWatchListStatus.execute(testId)),
    },
  );

  blocTest<DetailMovieBloc, DetailMovieState>(
    'should emit [DetailMovieLoading, DetailMovieError] when get detail data is unsuccessful',
    build: () {
      when(mockGetMovieDetail.execute(testId))
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));

      when(mockGetMovieRecommendations.execute(testId))
          .thenAnswer((_) async => Right(testMovieList));

      when(mockGetWatchListStatus.execute(testId))
          .thenAnswer((_) async => true);

      return detailMovieBloc;
    },
    act: (bloc) => bloc.add(DetailMovieGetEvent(testId)),
    expect: () => <DetailMovieState>[
      DetailMovieLoading(),
      DetailMovieError('Server Failure'),
    ],
    verify: (bloc) => {
      verify(mockGetMovieDetail.execute(testId)),
      verify(mockGetMovieRecommendations.execute(testId)),
      verify(mockGetWatchListStatus.execute(testId)),
    },
  );

  blocTest<DetailMovieBloc, DetailMovieState>(
    'should emit [DetailMovieLoading, DetailMovieError] when get data recommendations is unsuccessful',
    build: () {
      when(mockGetMovieDetail.execute(testId))
          .thenAnswer((_) async => Right(testMovieDetail));

      when(mockGetMovieRecommendations.execute(testId))
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));

      when(mockGetWatchListStatus.execute(testId))
          .thenAnswer((_) async => true);

      return detailMovieBloc;
    },
    act: (bloc) => bloc.add(DetailMovieGetEvent(testId)),
    expect: () => <DetailMovieState>[
      DetailMovieLoading(),
      DetailMovieError('Server Failure'),
    ],
    verify: (bloc) => {
      verify(mockGetMovieDetail.execute(testId)),
      verify(mockGetMovieRecommendations.execute(testId)),
      verify(mockGetWatchListStatus.execute(testId)),
    },
  );
}
