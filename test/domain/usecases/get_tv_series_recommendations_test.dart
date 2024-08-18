import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:ditonton/domain/usecases/get_tv_series_recommendations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../helpers/test_helper.mocks.dart';

void main() {
  late GetTvSeriesRecommendations usecase;
  late MockTvSeriesRepository mockTvSeriesRepository;

  setUp(() {
    mockTvSeriesRepository = MockTvSeriesRepository();
    usecase = GetTvSeriesRecommendations(mockTvSeriesRepository);
  });

  final tvId = 1;
  final List<TvSeries> tvSeries = [];

  test(
    'should get list recommendations tv series from repository based on id',
    () async {
      // arrange
      when(mockTvSeriesRepository.getTvSeriesRecommendations(tvId)).thenAnswer(
        (_) async => Right(tvSeries),
      );

      // act
      final result = await usecase.execute(tvId);

      // assert
      expect(result, Right(tvSeries));
    },
  );
}
