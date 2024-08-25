import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/usecases/get_top_rated_movies.dart';
import 'package:ditonton/presentation/bloc/movies/top_rated_movies/top_rated_movies_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'top_rated_movies_bloc_test.mocks.dart';

@GenerateMocks([GetTopRatedMovies])
void main() {
  late TopRatedMoviesBloc topRatedMoviesBloc;
  late MockGetTopRatedMovies mockGetTopRatedMovies;

  setUp(() {
    mockGetTopRatedMovies = MockGetTopRatedMovies();
    topRatedMoviesBloc = TopRatedMoviesBloc(
      getTopRatedMovies: mockGetTopRatedMovies,
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
    expect(topRatedMoviesBloc.state, TopRatedMoviesEmpty());
  });

  blocTest<TopRatedMoviesBloc, TopRatedMoviesState>(
    'should emit [TopRatedMoviesLoading, TopRatedMoviesHasData] when data is gotten successfully',
    build: () {
      when(mockGetTopRatedMovies.execute())
          .thenAnswer((_) async => Right(testMovieModelList));

      return topRatedMoviesBloc;
    },
    act: (bloc) => bloc.add(TopRatedMoviesGetEvent()),
    expect: () => <TopRatedMoviesState>[
      TopRatedMoviesLoading(),
      TopRatedMoviesHasData(testMovieModelList),
    ],
    verify: (bloc) => verify(mockGetTopRatedMovies.execute()),
  );

  blocTest<TopRatedMoviesBloc, TopRatedMoviesState>(
    'should emit [TopRatedMoviesLoading, TopRatedMoviesError] when get data is unsuccessful',
    build: () {
      when(mockGetTopRatedMovies.execute())
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));

      return topRatedMoviesBloc;
    },
    act: (bloc) => bloc.add(TopRatedMoviesGetEvent()),
    expect: () => <TopRatedMoviesState>[
      TopRatedMoviesLoading(),
      TopRatedMoviesError('Server Failure'),
    ],
    verify: (bloc) => verify(mockGetTopRatedMovies.execute()),
  );
}
