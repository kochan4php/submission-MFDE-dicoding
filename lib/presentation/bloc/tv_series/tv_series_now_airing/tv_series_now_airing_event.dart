part of 'tv_series_now_airing_bloc.dart';

abstract class TvSeriesNowAiringEvent extends Equatable {
  const TvSeriesNowAiringEvent();

  @override
  List<Object?> get props => [];
}

class TvSeriesNowAiringGetEvent extends TvSeriesNowAiringEvent {}
