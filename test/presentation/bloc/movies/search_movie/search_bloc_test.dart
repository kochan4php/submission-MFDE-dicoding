import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/usecases/search_movies.dart';
import 'package:ditonton/presentation/bloc/movies/search_movies/search_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'search_bloc_test.mocks.dart';

@GenerateMocks([SearchMovies])
void main() {
  late SearchBloc searchBloc;
  late MockSearchMovies mockSearchMovies;

  setUp(() {
    mockSearchMovies = MockSearchMovies();
    searchBloc = SearchBloc(searchMovies: mockSearchMovies);
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
    voteAverage: 2,
    voteCount: 2,
  );
  final testMovieModelList = <Movie>[testMovieModel];
  final testQuery = 'search';

  test('initial state should be empty', () {
    expect(searchBloc.state, SearchEmpty());
  });

  blocTest<SearchBloc, SearchState>(
    'should emit [SearchLoading, SearchHasData] when data is gotten successfully',
    build: () {
      when(mockSearchMovies.execute(testQuery)).thenAnswer(
        (_) async => Right(testMovieModelList),
      );

      return searchBloc;
    },
    act: (bloc) => bloc.add(OnQueryChanged(testQuery)),
    wait: Duration(milliseconds: 500),
    expect: () => <SearchState>[
      SearchLoading(),
      SearchHasData(testMovieModelList),
    ],
    verify: (bloc) {
      verify(mockSearchMovies.execute(testQuery));
    },
  );

  blocTest<SearchBloc, SearchState>(
    'should emit [SearchLoading, SearchError] when get search data is unsuccessful',
    build: () {
      when(mockSearchMovies.execute(testQuery)).thenAnswer(
        (_) async => Left(ServerFailure('Server Failure')),
      );

      return searchBloc;
    },
    act: (bloc) => bloc.add(OnQueryChanged(testQuery)),
    wait: Duration(milliseconds: 500),
    expect: () => <SearchState>[
      SearchLoading(),
      SearchError('Server Failure'),
    ],
    verify: (bloc) {
      verify(mockSearchMovies.execute(testQuery));
    },
  );
}
