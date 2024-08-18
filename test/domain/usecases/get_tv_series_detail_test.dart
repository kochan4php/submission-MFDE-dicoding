import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/usecases/get_tv_series_detail.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late GetTvSeriesDetail usecase;
  late MockTvSeriesRepository mockTvSeriesRepository;

  setUp(() {
    mockTvSeriesRepository = MockTvSeriesRepository();
    usecase = GetTvSeriesDetail(mockTvSeriesRepository);
  });

  final tvId = 1;

  test('should get detail tv series from repository', () async {
    // arrange
    when(mockTvSeriesRepository.getTvSeriesDetail(tvId)).thenAnswer(
      (_) async => Right(testTvSeriesDetail),
    );

    // act
    final result = await usecase.execute(tvId);

    // assert
    expect(result, Right(testTvSeriesDetail));
  });
}
