import 'package:bloc/bloc.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/entities/movie_detail.dart';
import 'package:ditonton/domain/usecases/get_movie_detail.dart';
import 'package:ditonton/domain/usecases/get_movie_recommendations.dart';
import 'package:ditonton/domain/usecases/get_watchlist_status.dart';
import 'package:equatable/equatable.dart';

part 'detail_movie_event.dart';
part 'detail_movie_state.dart';

class DetailMovieBloc extends Bloc<DetailMovieEvent, DetailMovieState> {
  final GetMovieDetail getMovieDetail;
  final GetMovieRecommendations getMovieRecommendations;
  final GetWatchListStatus getWatchListStatus;

  DetailMovieBloc({
    required this.getMovieDetail,
    required this.getMovieRecommendations,
    required this.getWatchListStatus,
  }) : super(DetailMovieEmpty()) {
    on<DetailMovieGetEvent>((event, emit) async {
      emit(DetailMovieLoading());

      final resultDetail = await getMovieDetail.execute(event.id);
      final isAddedToWatchlist = await getWatchListStatus.execute(event.id);
      final resultRecommendations = await getMovieRecommendations.execute(
        event.id,
      );

      resultDetail.fold(
        (failure) => emit(DetailMovieError(failure.message)),
        (dataDetail) => resultRecommendations.fold(
          (failure) => emit(DetailMovieError(failure.message)),
          (dataRecommendations) => emit(
            DetailMovieHasData(
              dataDetail,
              dataRecommendations,
              isAddedToWatchlist,
            ),
          ),
        ),
      );
    });
  }
}
