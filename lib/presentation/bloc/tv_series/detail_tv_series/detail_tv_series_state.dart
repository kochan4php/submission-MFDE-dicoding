part of 'detail_tv_series_bloc.dart';

abstract class DetailTvSeriesState extends Equatable {
  const DetailTvSeriesState();

  @override
  List<Object> get props => [];
}

class DetailTvSeriesEmpty extends DetailTvSeriesState {}

class DetailTvSeriesLoading extends DetailTvSeriesState {}

class DetailTvSeriesHasData extends DetailTvSeriesState {
  final TvSeriesDetail detailTvSeries;
  final List<TvSeries> recommendationsTvSeries;
  final bool isWatchlistTvSeries;

  DetailTvSeriesHasData(
    this.detailTvSeries,
    this.recommendationsTvSeries,
    this.isWatchlistTvSeries,
  );

  @override
  List<Object> get props => [
        detailTvSeries,
        recommendationsTvSeries,
        isWatchlistTvSeries,
      ];
}

class DetailTvSeriesError extends DetailTvSeriesState {
  final String message;

  DetailTvSeriesError(this.message);

  @override
  List<Object> get props => [message];
}
