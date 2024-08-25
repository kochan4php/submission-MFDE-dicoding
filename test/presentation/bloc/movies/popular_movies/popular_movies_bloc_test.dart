import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/usecases/get_popular_movies.dart';
import 'package:ditonton/presentation/bloc/movies/popular_movies/popular_movies_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'popular_movies_bloc_test.mocks.dart';

@GenerateMocks([GetPopularMovies])
void main() {
  late PopularMoviesBloc popularMoviesBloc;
  late MockGetPopularMovies mockGetPopularMovies;

  setUp(() {
    mockGetPopularMovies = MockGetPopularMovies();
    popularMoviesBloc = PopularMoviesBloc(
      getPopularMovies: mockGetPopularMovies,
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
    expect(popularMoviesBloc.state, PopularMoviesEmpty());
  });

  blocTest<PopularMoviesBloc, PopularMoviesState>(
    'should emit [PopularMoviesLoading, PopularMoviesHasData] when data is gotten successfully',
    build: () {
      when(mockGetPopularMovies.execute())
          .thenAnswer((_) async => Right(testMovieModelList));

      return popularMoviesBloc;
    },
    act: (bloc) => bloc.add(PopularMoviesGetEvent()),
    expect: () => <PopularMoviesState>[
      PopularMoviesLoading(),
      PopularMoviesHasData(testMovieModelList),
    ],
    verify: (bloc) => verify(mockGetPopularMovies.execute()),
  );

  blocTest<PopularMoviesBloc, PopularMoviesState>(
    'should emit [PopularMoviesLoading, PopularMoviesError] when get data is unsuccessful',
    build: () {
      when(mockGetPopularMovies.execute())
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));

      return popularMoviesBloc;
    },
    act: (bloc) => bloc.add(PopularMoviesGetEvent()),
    expect: () => <PopularMoviesState>[
      PopularMoviesLoading(),
      PopularMoviesError('Server Failure'),
    ],
    verify: (bloc) => verify(mockGetPopularMovies.execute()),
  );
}
