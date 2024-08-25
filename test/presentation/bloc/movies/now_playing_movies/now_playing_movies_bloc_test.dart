import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/usecases/get_now_playing_movies.dart';
import 'package:ditonton/presentation/bloc/movies/now_playing_movies/now_playing_movies_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'now_playing_movies_bloc_test.mocks.dart';

@GenerateMocks([GetNowPlayingMovies])
void main() {
  late NowPlayingMoviesBloc nowPlayingMoviesBloc;
  late MockGetNowPlayingMovies mockGetNowPlayingMovies;

  setUp(() {
    mockGetNowPlayingMovies = MockGetNowPlayingMovies();
    nowPlayingMoviesBloc = NowPlayingMoviesBloc(
      getNowPlayingMovies: mockGetNowPlayingMovies,
    );
  });

  final testMovieModel = Movie(
    adult: false,
    backdropPath: 'backdropPath',
    genreIds: [1],
    id: 1,
    originalTitle: 'originalTitle',
    overview: 'overview',
    popularity: 1,
    posterPath: 'posterPath',
    releaseDate: 'releaseDate',
    title: 'title',
    video: true,
    voteAverage: 1,
    voteCount: 1,
  );

  final testMovieModelList = [testMovieModel];

  test('initial state should be empty', () {
    expect(nowPlayingMoviesBloc.state, NowPlayingMoviesEmpty());
  });

  blocTest<NowPlayingMoviesBloc, NowPlayingMoviesState>(
    'should emit [NowPlayingMoviesLoading, NowPlayingMoviesHasData] when data is gotten successfully',
    build: () {
      when(mockGetNowPlayingMovies.execute())
          .thenAnswer((_) async => Right(testMovieModelList));

      return nowPlayingMoviesBloc;
    },
    act: (bloc) => bloc.add(NowPlayingMoviesGetEvent()),
    expect: () => <NowPlayingMoviesState>[
      NowPlayingMoviesLoading(),
      NowPlayingMoviesHasData(testMovieModelList),
    ],
    verify: (bloc) => verify(mockGetNowPlayingMovies.execute()),
  );

  blocTest<NowPlayingMoviesBloc, NowPlayingMoviesState>(
    'should emit [NowPlayingMoviesLoading, NowPlayingMoviesError] when get data is unsuccessful',
    build: () {
      when(mockGetNowPlayingMovies.execute())
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));

      return nowPlayingMoviesBloc;
    },
    act: (bloc) => bloc.add(NowPlayingMoviesGetEvent()),
    expect: () => <NowPlayingMoviesState>[
      NowPlayingMoviesLoading(),
      NowPlayingMoviesError('Server Failure'),
    ],
    verify: (bloc) => verify(mockGetNowPlayingMovies.execute()),
  );
}
