import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:ditonton/domain/usecases/get_watchlist_tv_series.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../helpers/test_helper.mocks.dart';

void main() {
  late GetWatchlistTvSeries usecase;
  late MockTvSeriesRepository mockTvSeriesRepository;

  setUp(() {
    mockTvSeriesRepository = MockTvSeriesRepository();
    usecase = GetWatchlistTvSeries(mockTvSeriesRepository);
  });

  final List<TvSeries> tvSeries = [];

  test('should get list watchlist tv series from repository', () async {
    // arrange
    when(mockTvSeriesRepository.getWatchlistTvSeries()).thenAnswer(
      (_) async => Right(tvSeries),
    );

    // act
    final result = await usecase.execute();

    // assert
    expect(result, Right(tvSeries));
  });
}
