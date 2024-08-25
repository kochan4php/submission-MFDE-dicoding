import 'package:bloc/bloc.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:ditonton/domain/usecases/get_airing_tv_series.dart';
import 'package:equatable/equatable.dart';

part 'tv_series_now_airing_event.dart';
part 'tv_series_now_airing_state.dart';

class TvSeriesNowAiringBloc
    extends Bloc<TvSeriesNowAiringEvent, TvSeriesNowAiringState> {
  final GetAiringTvSeries getAiringTvSeries;

  TvSeriesNowAiringBloc({required this.getAiringTvSeries})
      : super(TvSeriesNowAiringEmpty()) {
    on<TvSeriesNowAiringGetEvent>((event, emit) async {
      emit(TvSeriesNowAiringLoading());

      final result = await getAiringTvSeries.execute();

      result.fold(
        (failure) => emit(TvSeriesNowAiringError(failure.message)),
        (data) => emit(TvSeriesNowAiringHasData(data)),
      );
    });
  }
}
