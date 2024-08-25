part of 'popular_tv_series_bloc.dart';

sealed class PopularTvSeriesState extends Equatable {
  const PopularTvSeriesState();

  @override
  List<Object?> get props => [];
}

class PopularTvSeriesEmpty extends PopularTvSeriesState {}

class PopularTvSeriesLoading extends PopularTvSeriesState {}

class PopularTvSeriesHasData extends PopularTvSeriesState {
  final List<TvSeries> tvSeries;

  PopularTvSeriesHasData(this.tvSeries);

  @override
  List<Object?> get props => [tvSeries];
}

class PopularTvSeriesError extends PopularTvSeriesState {
  final String message;

  PopularTvSeriesError(this.message);

  @override
  List<Object?> get props => [message];
}
