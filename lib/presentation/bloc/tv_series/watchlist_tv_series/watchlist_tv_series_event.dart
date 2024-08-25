part of 'watchlist_tv_series_bloc.dart';

abstract class WatchlistTvSeriesEvent extends Equatable {
  const WatchlistTvSeriesEvent();

  @override
  List<Object?> get props => [];
}

class WatchlistTvSeriesGetEvent extends WatchlistTvSeriesEvent {}

class WatchlistTvSeriesAddEvent extends WatchlistTvSeriesEvent {
  final TvSeriesDetail tvSeriesDetail;

  WatchlistTvSeriesAddEvent(this.tvSeriesDetail);

  @override
  List<Object?> get props => [tvSeriesDetail];
}

class WatchlistTvSeriesRemoveEvent extends WatchlistTvSeriesEvent {
  final TvSeriesDetail tvSeriesDetail;

  WatchlistTvSeriesRemoveEvent(this.tvSeriesDetail);

  @override
  List<Object?> get props => [tvSeriesDetail];
}
