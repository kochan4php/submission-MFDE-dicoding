import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/usecases/remove_watchlist_tv_series.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late RemoveWatchlistTvSeries usecase;
  late MockTvSeriesRepository mockTvSeriesRepository;

  setUp(() {
    mockTvSeriesRepository = MockTvSeriesRepository();
    usecase = RemoveWatchlistTvSeries(mockTvSeriesRepository);
  });

  test('should remove tv series watchlist movie from repository', () async {
    // arrange
    when(mockTvSeriesRepository.removeWatchlistTvSeries(testTvSeriesDetail))
        .thenAnswer((_) async => Right('Remove tv series from watchlist'));

    // act
    final result = await usecase.execute(testTvSeriesDetail);

    // assert
    verify(mockTvSeriesRepository.removeWatchlistTvSeries(testTvSeriesDetail));
    expect(result, Right('Remove tv series from watchlist'));
  });
}
