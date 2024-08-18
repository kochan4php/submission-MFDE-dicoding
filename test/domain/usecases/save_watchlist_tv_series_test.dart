import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/usecases/save_watchlist_tv_series.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late SaveWatchlistTvSeries usecase;
  late MockTvSeriesRepository mockTvSeriesRepository;

  setUp(() {
    mockTvSeriesRepository = MockTvSeriesRepository();
    usecase = SaveWatchlistTvSeries(mockTvSeriesRepository);
  });

  test('should remove tv series watchlist movie from repository', () async {
    // arrange
    when(mockTvSeriesRepository.saveWatchlistTvSeries(testTvSeriesDetail))
        .thenAnswer((_) async => Right('Added tv series to watchlist'));

    // act
    final result = await usecase.execute(testTvSeriesDetail);

    // assert
    verify(mockTvSeriesRepository.saveWatchlistTvSeries(testTvSeriesDetail));
    expect(result, Right('Added tv series to watchlist'));
  });
}
