part of 'detail_tv_series_bloc.dart';

abstract class DetailTvSeriesEvent extends Equatable {
  const DetailTvSeriesEvent();

  @override
  List<Object?> get props => [];
}

class DetailTvSeriesGetEvent extends DetailTvSeriesEvent {
  final int id;

  DetailTvSeriesGetEvent(this.id);

  @override
  List<Object?> get props => [id];
}
