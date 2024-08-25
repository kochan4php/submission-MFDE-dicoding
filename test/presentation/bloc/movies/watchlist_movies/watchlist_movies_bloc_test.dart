import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/usecases/get_watchlist_movies.dart';
import 'package:ditonton/domain/usecases/remove_watchlist.dart';
import 'package:ditonton/domain/usecases/save_watchlist.dart';
import 'package:ditonton/presentation/bloc/movies/watchlist_movies/watchlist_movies_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../../dummy_data/dummy_objects.dart';
import 'watchlist_movies_bloc_test.mocks.dart';

@GenerateMocks([SaveWatchlist, RemoveWatchlist, GetWatchlistMovies])
void main() {
  late WatchlistMoviesBloc watchlistMoviesBloc;
  late MockGetWatchlistMovies mockGetWatchlistMovies;
  late MockSaveWatchlist mockSaveWatchlist;
  late MockRemoveWatchlist mockRemoveWatchlist;

  setUp(() {
    mockSaveWatchlist = MockSaveWatchlist();
    mockRemoveWatchlist = MockRemoveWatchlist();
    mockGetWatchlistMovies = MockGetWatchlistMovies();
    watchlistMoviesBloc = WatchlistMoviesBloc(
      saveWatchlist: mockSaveWatchlist,
      removeWatchlist: mockRemoveWatchlist,
      getWatchlistMovies: mockGetWatchlistMovies,
    );
  });

  test('initial state should be WatchlistMoviesInitial', () {
    expect(watchlistMoviesBloc.state, WatchlistMoviesInitial());
  });

  group('Get Watchlist Movies', () {
    blocTest<WatchlistMoviesBloc, WatchlistMoviesState>(
      'should emit [WatchlistMoviesLoading, WatchlistMoviesHasData] when get watchlist data is successful',
      build: () {
        when(mockGetWatchlistMovies.execute())
            .thenAnswer((_) async => Right(testMovieList));

        return watchlistMoviesBloc;
      },
      act: (bloc) => bloc.add(WatchlistMovieGetEvent()),
      expect: () => <WatchlistMoviesState>[
        WatchlistMoviesLoading(),
        WatchlistMoviesHasData(testMovieList),
      ],
      verify: (bloc) => mockGetWatchlistMovies.execute(),
    );

    blocTest<WatchlistMoviesBloc, WatchlistMoviesState>(
      'should emit [WatchlistMoviesLoading, WatchlistMoviesError] when get watchlist data is unsuccessful',
      build: () {
        when(mockGetWatchlistMovies.execute())
            .thenAnswer((_) async => Left(ServerFailure('Server Failure')));

        return watchlistMoviesBloc;
      },
      act: (bloc) => bloc.add(WatchlistMovieGetEvent()),
      expect: () => <WatchlistMoviesState>[
        WatchlistMoviesLoading(),
        WatchlistMoviesError('Server Failure'),
      ],
      verify: (bloc) => mockGetWatchlistMovies.execute(),
    );
  });

  group('Save Movie to Watchlist', () {
    blocTest<WatchlistMoviesBloc, WatchlistMoviesState>(
      'should emit [WatchlistMoviesLoading, WatchlistMoviesSuccess] when save to watchlist is successful',
      build: () {
        when(mockSaveWatchlist.execute(testMovieDetail))
            .thenAnswer((_) async => Right('Success add movie to watchlist'));

        return watchlistMoviesBloc;
      },
      act: (bloc) => bloc.add(WatchlistMovieSaveEvent(testMovieDetail)),
      expect: () => <WatchlistMoviesState>[
        WatchlistMoviesLoading(),
        WatchlistMoviesSuccess('Success add movie to watchlist'),
      ],
      verify: (bloc) => mockSaveWatchlist.execute(testMovieDetail),
    );

    blocTest<WatchlistMoviesBloc, WatchlistMoviesState>(
      'should emit [WatchlistMoviesLoading, WatchlistMoviesError] when save to watchlist is unsuccessful',
      build: () {
        when(mockSaveWatchlist.execute(testMovieDetail))
            .thenAnswer((_) async => Left(DatabaseFailure('Database Failure')));

        return watchlistMoviesBloc;
      },
      act: (bloc) => bloc.add(WatchlistMovieSaveEvent(testMovieDetail)),
      expect: () => <WatchlistMoviesState>[
        WatchlistMoviesLoading(),
        WatchlistMoviesError('Database Failure'),
      ],
      verify: (bloc) => mockSaveWatchlist.execute(testMovieDetail),
    );
  });

  group('Remove Movie from Watchlist', () {
    blocTest<WatchlistMoviesBloc, WatchlistMoviesState>(
      'should emit [WatchlistMoviesLoading, WatchlistMoviesSuccess] when remove from watchlist is successful',
      build: () {
        when(mockRemoveWatchlist.execute(testMovieDetail)).thenAnswer(
            (_) async => Right('Success remove movie from watchlist'));

        return watchlistMoviesBloc;
      },
      act: (bloc) => bloc.add(WatchlistMovieRemoveEvent(testMovieDetail)),
      expect: () => <WatchlistMoviesState>[
        WatchlistMoviesLoading(),
        WatchlistMoviesSuccess('Success remove movie from watchlist'),
      ],
      verify: (bloc) => mockRemoveWatchlist.execute(testMovieDetail),
    );

    blocTest<WatchlistMoviesBloc, WatchlistMoviesState>(
      'should emit [WatchlistMoviesLoading, WatchlistMoviesError] when remove from watchlist is unsuccessful',
      build: () {
        when(mockRemoveWatchlist.execute(testMovieDetail))
            .thenAnswer((_) async => Left(DatabaseFailure('Database Failure')));

        return watchlistMoviesBloc;
      },
      act: (bloc) => bloc.add(WatchlistMovieRemoveEvent(testMovieDetail)),
      expect: () => <WatchlistMoviesState>[
        WatchlistMoviesLoading(),
        WatchlistMoviesError('Database Failure'),
      ],
      verify: (bloc) => mockRemoveWatchlist.execute(testMovieDetail),
    );
  });
}
