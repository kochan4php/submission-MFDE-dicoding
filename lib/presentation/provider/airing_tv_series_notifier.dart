import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:ditonton/domain/usecases/get_airing_tv_series.dart';
import 'package:flutter/foundation.dart';

class AiringTvSeriesNotifier extends ChangeNotifier {
  List<TvSeries> _airingTvSeries = [];
  List<TvSeries> get airingTvSeries => _airingTvSeries;

  RequestState _airingState = RequestState.Empty;
  RequestState get airingState => _airingState;

  String _message = '';
  String get message => _message;

  AiringTvSeriesNotifier({required this.getAiringTvSeries});

  final GetAiringTvSeries getAiringTvSeries;

  Future fetchAiringTvSeries() async {
    _airingState = RequestState.Loading;
    notifyListeners();

    final result = await getAiringTvSeries.execute();

    result.fold(
      (failure) {
        _airingState = RequestState.Error;
        _message = failure.message;
        notifyListeners();
      },
      (data) {
        _airingState = RequestState.Loaded;
        _airingTvSeries = data;
        notifyListeners();
      },
    );
  }
}
