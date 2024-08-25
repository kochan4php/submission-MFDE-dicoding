import 'package:bloc/bloc.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/entities/movie_detail.dart';
import 'package:ditonton/domain/usecases/get_watchlist_movies.dart';
import 'package:ditonton/domain/usecases/remove_watchlist.dart';
import 'package:ditonton/domain/usecases/save_watchlist.dart';
import 'package:equatable/equatable.dart';

part 'watchlist_movies_event.dart';
part 'watchlist_movies_state.dart';

class WatchlistMoviesBloc
    extends Bloc<WatchlistMoviesEvent, WatchlistMoviesState> {
  final SaveWatchlist saveWatchlist;
  final RemoveWatchlist removeWatchlist;
  final GetWatchlistMovies getWatchlistMovies;

  WatchlistMoviesBloc({
    required this.saveWatchlist,
    required this.removeWatchlist,
    required this.getWatchlistMovies,
  }) : super(WatchlistMoviesInitial()) {
    on<WatchlistMovieGetEvent>((event, emit) async {
      emit(WatchlistMoviesLoading());

      final result = await getWatchlistMovies.execute();

      result.fold(
        (failure) => emit(WatchlistMoviesError(failure.message)),
        (data) => emit(WatchlistMoviesHasData(data)),
      );
    });

    on<WatchlistMovieSaveEvent>((event, emit) async {
      emit(WatchlistMoviesLoading());

      final result = await saveWatchlist.execute(event.movieDetail);

      result.fold(
        (failure) => emit(WatchlistMoviesError(failure.message)),
        (data) => emit(WatchlistMoviesSuccess(data)),
      );
    });

    on<WatchlistMovieRemoveEvent>((event, emit) async {
      emit(WatchlistMoviesLoading());

      final result = await removeWatchlist.execute(event.movieDetail);

      result.fold(
        (failure) => emit(WatchlistMoviesError(failure.message)),
        (data) => emit(WatchlistMoviesSuccess(data)),
      );
    });
  }
}
