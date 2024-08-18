import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:ditonton/domain/usecases/search_tv_series.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../helpers/test_helper.mocks.dart';

void main() {
  late SearchTvSeries usecase;
  late MockTvSeriesRepository mockTvSeriesRepository;

  setUp(() {
    mockTvSeriesRepository = MockTvSeriesRepository();
    usecase = SearchTvSeries(mockTvSeriesRepository);
  });

  final List<TvSeries> tvSeries = [];
  final query = 'frieren';

  test('should get list searched tv series from repository', () async {
    // arrange
    when(mockTvSeriesRepository.searchTvSeries(query)).thenAnswer(
      (_) async => Right(tvSeries),
    );

    // act
    final result = await usecase.execute(query);

    // assert
    verify(mockTvSeriesRepository.searchTvSeries(query));
    expect(result, Right(tvSeries));
  });
}
