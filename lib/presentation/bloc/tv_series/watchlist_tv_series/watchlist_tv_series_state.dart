part of 'watchlist_tv_series_bloc.dart';

abstract class WatchlistTvSeriesState extends Equatable {
  const WatchlistTvSeriesState();

  @override
  List<Object?> get props => [];
}

class WatchlistTvSeriesInitial extends WatchlistTvSeriesState {}

class WatchlistTvSeriesLoading extends WatchlistTvSeriesState {}

class WatchlistTvSeriesHasData extends WatchlistTvSeriesState {
  final List<TvSeries> tvSeries;

  WatchlistTvSeriesHasData(this.tvSeries);

  @override
  List<Object?> get props => [tvSeries];
}

class WatchlistTvSeriesSuccess extends WatchlistTvSeriesState {
  final String message;

  WatchlistTvSeriesSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class WatchlistTvSeriesError extends WatchlistTvSeriesState {
  final String message;

  WatchlistTvSeriesError(this.message);

  @override
  List<Object?> get props => [message];
}
