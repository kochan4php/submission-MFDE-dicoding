import 'package:bloc/bloc.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:ditonton/domain/entities/tv_series_detail.dart';
import 'package:ditonton/domain/usecases/get_watchlist_tv_series.dart';
import 'package:ditonton/domain/usecases/remove_watchlist_tv_series.dart';
import 'package:ditonton/domain/usecases/save_watchlist_tv_series.dart';
import 'package:equatable/equatable.dart';

part 'watchlist_tv_series_event.dart';
part 'watchlist_tv_series_state.dart';

class WatchlistTvSeriesBloc
    extends Bloc<WatchlistTvSeriesEvent, WatchlistTvSeriesState> {
  final GetWatchlistTvSeries getWatchlistTvSeries;
  final SaveWatchlistTvSeries saveWatchlistTvSeries;
  final RemoveWatchlistTvSeries removeWatchlistTvSeries;

  WatchlistTvSeriesBloc({
    required this.getWatchlistTvSeries,
    required this.saveWatchlistTvSeries,
    required this.removeWatchlistTvSeries,
  }) : super(WatchlistTvSeriesInitial()) {
    on<WatchlistTvSeriesGetEvent>((event, emit) async {
      emit(WatchlistTvSeriesLoading());

      final result = await getWatchlistTvSeries.execute();

      result.fold(
        (failure) => emit(WatchlistTvSeriesError(failure.message)),
        (data) => emit(WatchlistTvSeriesHasData(data)),
      );
    });

    on<WatchlistTvSeriesAddEvent>((event, emit) async {
      emit(WatchlistTvSeriesLoading());

      final result = await saveWatchlistTvSeries.execute(event.tvSeriesDetail);

      result.fold(
        (failure) => emit(WatchlistTvSeriesError(failure.message)),
        (data) => emit(WatchlistTvSeriesSuccess(data)),
      );
    });

    on<WatchlistTvSeriesRemoveEvent>((event, emit) async {
      emit(WatchlistTvSeriesLoading());

      final result = await removeWatchlistTvSeries.execute(
        event.tvSeriesDetail,
      );

      result.fold(
        (failure) => emit(WatchlistTvSeriesError(failure.message)),
        (data) => emit(WatchlistTvSeriesSuccess(data)),
      );
    });
  }
}
