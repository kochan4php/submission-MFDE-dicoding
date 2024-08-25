part of 'tv_series_search_bloc.dart';

abstract class TvSeriesSearchState extends Equatable {
  const TvSeriesSearchState();

  @override
  List<Object?> get props => [];
}

class TvSeriesSearchEmpty extends TvSeriesSearchState {}

class TvSeriesSearchLoading extends TvSeriesSearchState {}

class TvSeriesSearchHasData extends TvSeriesSearchState {
  final List<TvSeries> tvSeries;

  TvSeriesSearchHasData(this.tvSeries);

  @override
  List<Object?> get props => [tvSeries];
}

class TvSeriesSearchError extends TvSeriesSearchState {
  final String message;

  TvSeriesSearchError(this.message);

  @override
  List<Object?> get props => [message];
}
