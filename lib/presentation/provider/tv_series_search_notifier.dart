import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:ditonton/domain/usecases/search_tv_series.dart';
import 'package:flutter/foundation.dart';

class TvSeriesSearchNotifier extends ChangeNotifier {
  List<TvSeries> _searchedTvSeries = [];
  List<TvSeries> get searchedTvSeries => _searchedTvSeries;

  RequestState _searchTvSeriesState = RequestState.Empty;
  RequestState get searchTvSeriesState => _searchTvSeriesState;

  String _message = '';
  String get message => _message;

  TvSeriesSearchNotifier({required this.searchTvSeries});

  final SearchTvSeries searchTvSeries;

  Future fetchTvSeriesSearch(String query) async {
    _searchTvSeriesState = RequestState.Loading;
    notifyListeners();

    final result = await searchTvSeries.execute(query);

    result.fold(
      (failure) {
        _searchTvSeriesState = RequestState.Error;
        _message = failure.message;
        notifyListeners();
      },
      (data) {
        _searchTvSeriesState = RequestState.Loaded;
        _searchedTvSeries = data;
        notifyListeners();
      },
    );
  }
}
