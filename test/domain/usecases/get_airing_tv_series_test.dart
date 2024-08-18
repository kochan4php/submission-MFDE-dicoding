import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:ditonton/domain/usecases/get_airing_tv_series.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../helpers/test_helper.mocks.dart';

void main() {
  late GetAiringTvSeries usecase;
  late MockTvSeriesRepository mockTvSeriesRepository;

  setUp(() {
    mockTvSeriesRepository = MockTvSeriesRepository();
    usecase = GetAiringTvSeries(mockTvSeriesRepository);
  });

  final List<TvSeries> tvSeries = [];

  test('should get list airing tv series from repository', () async {
    // arrange
    when(mockTvSeriesRepository.getAiringTvSeries()).thenAnswer(
      (_) async => Right(tvSeries),
    );

    // act
    final result = await usecase.execute();

    // assert
    expect(result, Right(tvSeries));
  });
}
