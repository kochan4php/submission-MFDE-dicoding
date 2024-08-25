part of 'tv_series_now_airing_bloc.dart';

abstract class TvSeriesNowAiringState extends Equatable {
  const TvSeriesNowAiringState();

  @override
  List<Object> get props => [];
}

class TvSeriesNowAiringEmpty extends TvSeriesNowAiringState {}

class TvSeriesNowAiringLoading extends TvSeriesNowAiringState {}

class TvSeriesNowAiringHasData extends TvSeriesNowAiringState {
  final List<TvSeries> tvSeries;

  TvSeriesNowAiringHasData(this.tvSeries);

  @override
  List<Object> get props => [tvSeries];
}

class TvSeriesNowAiringError extends TvSeriesNowAiringState {
  final String message;

  TvSeriesNowAiringError(this.message);

  @override
  List<Object> get props => [message];
}
