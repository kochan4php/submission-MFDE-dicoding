import 'package:bloc/bloc.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:ditonton/domain/entities/tv_series_detail.dart';
import 'package:ditonton/domain/usecases/get_tv_series_detail.dart';
import 'package:ditonton/domain/usecases/get_tv_series_recommendations.dart';
import 'package:ditonton/domain/usecases/get_tv_series_watchlist_status.dart';
import 'package:equatable/equatable.dart';

part 'detail_tv_series_event.dart';
part 'detail_tv_series_state.dart';

class DetailTvSeriesBloc
    extends Bloc<DetailTvSeriesEvent, DetailTvSeriesState> {
  final GetTvSeriesDetail getTvSeriesDetail;
  final GetTvSeriesRecommendations getTvSeriesRecommendations;
  final GetTvSeriesWatchlistStatus getTvSeriesWatchlistStatus;

  DetailTvSeriesBloc({
    required this.getTvSeriesDetail,
    required this.getTvSeriesRecommendations,
    required this.getTvSeriesWatchlistStatus,
  }) : super(DetailTvSeriesEmpty()) {
    on<DetailTvSeriesGetEvent>((event, emit) async {
      emit(DetailTvSeriesLoading());

      final int id = event.id;

      final resultDetail = await getTvSeriesDetail.execute(id);
      final resultRecommendation = await getTvSeriesRecommendations.execute(id);
      final isTvSeriesWatchlist = await getTvSeriesWatchlistStatus.execute(id);

      resultDetail.fold(
        (failureDetail) => emit(DetailTvSeriesError(failureDetail.message)),
        (dataDetail) => resultRecommendation.fold(
          (failure) => emit(DetailTvSeriesError(failure.message)),
          (dataRecommendations) => emit(
            DetailTvSeriesHasData(
              dataDetail,
              dataRecommendations,
              isTvSeriesWatchlist,
            ),
          ),
        ),
      );
    });
  }
}
