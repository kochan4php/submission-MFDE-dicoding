part of 'top_rated_tv_series_bloc.dart';

abstract class TopRatedTvSeriesState extends Equatable {
  const TopRatedTvSeriesState();

  @override
  List<Object> get props => [];
}

class TopRatedTvSeriesEmpty extends TopRatedTvSeriesState {}

class TopRatedTvSeriesLoading extends TopRatedTvSeriesState {}

class TopRatedTvSeriesHasData extends TopRatedTvSeriesState {
  final List<TvSeries> tvSeries;

  TopRatedTvSeriesHasData(this.tvSeries);

  @override
  List<Object> get props => [tvSeries];
}

class TopRatedTvSeriesError extends TopRatedTvSeriesState {
  final String message;

  TopRatedTvSeriesError(this.message);

  @override
  List<Object> get props => [message];
}
