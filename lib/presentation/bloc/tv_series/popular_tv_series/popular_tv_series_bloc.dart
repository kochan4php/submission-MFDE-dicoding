import 'package:bloc/bloc.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:ditonton/domain/usecases/get_popular_tv_series.dart';
import 'package:equatable/equatable.dart';

part 'popular_tv_series_event.dart';
part 'popular_tv_series_state.dart';

class PopularTvSeriesBloc
    extends Bloc<PopularTvSeriesEvent, PopularTvSeriesState> {
  final GetPopularTvSeries getPopularTvSeries;

  PopularTvSeriesBloc({required this.getPopularTvSeries})
      : super(PopularTvSeriesEmpty()) {
    on<PopularTvSeriesGetEvent>((event, emit) async {
      emit(PopularTvSeriesLoading());

      final result = await getPopularTvSeries.execute();

      result.fold(
        (failure) => emit(PopularTvSeriesError(failure.message)),
        (data) => emit(PopularTvSeriesHasData(data)),
      );
    });
  }
}
