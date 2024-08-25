import 'package:bloc/bloc.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:ditonton/domain/usecases/search_tv_series.dart';
import 'package:equatable/equatable.dart';
import 'package:rxdart/rxdart.dart';

part 'tv_series_search_event.dart';
part 'tv_series_search_state.dart';

class TvSeriesSearchBloc
    extends Bloc<TvSeriesSearchEvent, TvSeriesSearchState> {
  final SearchTvSeries searchTvSeries;

  TvSeriesSearchBloc({required this.searchTvSeries})
      : super(TvSeriesSearchEmpty()) {
    on<OnTvSeriesQueryChanged>(
      (event, emit) async {
        final String query = event.query;

        emit(TvSeriesSearchLoading());

        final result = await searchTvSeries.execute(query);

        result.fold(
          (failure) {
            emit(TvSeriesSearchError(failure.message));
          },
          (data) {
            emit(TvSeriesSearchHasData(data));
          },
        );
      },
      transformer: (events, mapper) {
        return events.debounceTime(Duration(milliseconds: 500)).flatMap(mapper);
      },
    );
  }
}
