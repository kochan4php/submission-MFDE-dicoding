import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:ditonton/domain/usecases/get_popular_tv_series.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../helpers/test_helper.mocks.dart';

void main() {
  late GetPopularTvSeries usecase;
  late MockTvSeriesRepository mockTvSeriesRepository;

  setUp(() {
    mockTvSeriesRepository = MockTvSeriesRepository();
    usecase = GetPopularTvSeries(mockTvSeriesRepository);
  });

  final List<TvSeries> tvSeries = [];

  test('should get list popular tv series from repository', () async {
    // arrange
    when(mockTvSeriesRepository.getPopularTvSeries()).thenAnswer(
      (_) async => Right(tvSeries),
    );

    // act
    final result = await usecase.execute();

    // assert
    expect(result, Right(tvSeries));
  });
}
