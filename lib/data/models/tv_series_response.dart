import 'package:ditonton/data/models/tv_series_model.dart';
import 'package:equatable/equatable.dart';

class TvSeriesResponse extends Equatable {
  final List<TvSeriesModel> tvSeriesList;

  TvSeriesResponse({required this.tvSeriesList});

  factory TvSeriesResponse.fromJson(Map<String, dynamic> json) {
    return TvSeriesResponse(
      tvSeriesList: List<TvSeriesModel>.from((json['results'] as List)
          .map((tvSeries) => TvSeriesModel.fromJson(tvSeries))),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'tvSeriesList': List<TvSeriesModel>.from(
        tvSeriesList.map((x) => x.toJson()),
      ),
    };
  }

  @override
  List<Object?> get props => [tvSeriesList];
}
