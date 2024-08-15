import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:ditonton/domain/entities/tv_series_detail.dart';
import 'package:equatable/equatable.dart';

class TvSeriesTable extends Equatable {
  TvSeriesTable({
    required this.id,
    required this.overview,
    required this.posterPath,
    required this.name,
  });

  final int id;
  final String overview;
  final String? posterPath;
  final String name;

  factory TvSeriesTable.fromMap(Map<String, dynamic> map) {
    return TvSeriesTable(
      id: map['id'],
      overview: map['overview'],
      posterPath: map['posterPath'],
      name: map['name'],
    );
  }

  factory TvSeriesTable.fromEntity(TvSeriesDetail tvSeries) {
    return TvSeriesTable(
      id: tvSeries.id,
      overview: tvSeries.overview,
      posterPath: tvSeries.posterPath,
      name: tvSeries.name,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'overview': overview,
      'posterPath': posterPath,
      'name': name,
    };
  }

  TvSeries toEntity() {
    return TvSeries.watchList(
      id: id,
      overview: overview,
      posterPath: posterPath,
      name: name,
    );
  }

  @override
  List<Object?> get props => [id, overview, posterPath, name];
}
