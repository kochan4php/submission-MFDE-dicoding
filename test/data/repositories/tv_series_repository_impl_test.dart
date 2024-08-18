import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:ditonton/common/exception.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/data/models/genre_model.dart';
import 'package:ditonton/data/models/tv_series_detail_model.dart';
import 'package:ditonton/data/models/tv_series_model.dart';
import 'package:ditonton/data/repositories/tv_series_repository_impl.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late TvSeriesRepositoryImpl repository;
  late MockTvSeriesRemoteDataSource mockTvSeriesRemoteDataSource;
  late MockTvSeriesLocalDataSource mockTvSeriesLocalDataSource;

  setUp(() {
    mockTvSeriesLocalDataSource = MockTvSeriesLocalDataSource();
    mockTvSeriesRemoteDataSource = MockTvSeriesRemoteDataSource();
    repository = TvSeriesRepositoryImpl(
      remoteDataSource: mockTvSeriesRemoteDataSource,
      localDataSource: mockTvSeriesLocalDataSource,
    );
  });

  final testTvSeriesModel = TvSeriesModel(
    adult: false,
    genreIds: [1, 2],
    id: 1,
    originalLanguage: 'en',
    originalName: 'Frieren',
    overview: 'overview',
    popularity: 100,
    posterPath: '/rweIrveL43TaxUN0akQEaAXL6x0.jpg',
    backdropPath: '/rweIrveL43TaxUN0akQEaAXL6x0.jpg',
    firstAirDate: '2023-06-01',
    name: 'Souso no Frieren',
    voteAverage: 9.2,
    voteCount: 100304,
    originCountry: ['US'],
  );

  final testTvSeries = TvSeries(
    adult: false,
    genreIds: [1, 2],
    id: 1,
    originalLanguage: 'en',
    originalName: 'Frieren',
    overview: 'overview',
    popularity: 100,
    posterPath: '/rweIrveL43TaxUN0akQEaAXL6x0.jpg',
    firstAirDate: '2023-06-01',
    name: 'Souso no Frieren',
    voteAverage: 9.2,
    voteCount: 100304,
  );

  final List<TvSeriesModel> testTvSeriesModelList = [testTvSeriesModel];
  final List<TvSeries> testTvSeriesList = [testTvSeries];

  group('Get Airing Tv Series', () {
    test(
      'should return remote data when the call to remote data source is successful',
      () async {
        // arrange
        when(mockTvSeriesRemoteDataSource.getAiringTvSeries()).thenAnswer(
          (_) async => testTvSeriesModelList,
        );

        // act
        final result = await repository.getAiringTvSeries();

        // assert
        final resultList = result.getOrElse(() => []);
        verify(mockTvSeriesRemoteDataSource.getAiringTvSeries());
        expect(resultList, testTvSeriesList);
      },
    );

    test(
      'should return server failure when the call to remote data source is unsuccessful',
      () async {
        // arrange
        when(mockTvSeriesRemoteDataSource.getAiringTvSeries()).thenThrow(
          ServerException(),
        );

        // act
        final result = await repository.getAiringTvSeries();

        // assert
        verify(mockTvSeriesRemoteDataSource.getAiringTvSeries());
        expect(result, equals(Left(ServerFailure(''))));
      },
    );

    test(
      'should return connection failure when the device is not connected to internet',
      () async {
        // arrange
        when(mockTvSeriesRemoteDataSource.getAiringTvSeries()).thenThrow(
          SocketException(TvSeriesRepositoryImpl.noConnectionMessage),
        );

        // act
        final result = await repository.getAiringTvSeries();

        // assert
        verify(mockTvSeriesRemoteDataSource.getAiringTvSeries());
        expect(
          result,
          equals(
            Left(ConnectionFailure(TvSeriesRepositoryImpl.noConnectionMessage)),
          ),
        );
      },
    );
  });

  group('Get Popular Tv Series', () {
    test(
      'should return movie list when call to data source is successful',
      () async {
        // arrange
        when(mockTvSeriesRemoteDataSource.getPopularTvSeries()).thenAnswer(
          (_) async => testTvSeriesModelList,
        );

        // act
        final result = await repository.getPopularTvSeries();

        // assert
        final resultList = result.getOrElse(() => []);
        verify(mockTvSeriesRemoteDataSource.getPopularTvSeries());
        expect(resultList, testTvSeriesList);
      },
    );

    test(
      'should return server failure when call to data source is unsuccessful',
      () async {
        // arrange
        when(mockTvSeriesRemoteDataSource.getPopularTvSeries()).thenThrow(
          ServerException(),
        );

        // act
        final result = await repository.getPopularTvSeries();

        // assert
        verify(mockTvSeriesRemoteDataSource.getPopularTvSeries());
        expect(result, Left(ServerFailure('')));
      },
    );

    test(
      'should return connection failure when the device is not connected to the internet',
      () async {
        // arrange
        when(mockTvSeriesRemoteDataSource.getPopularTvSeries()).thenThrow(
          SocketException(TvSeriesRepositoryImpl.noConnectionMessage),
        );

        // act
        final result = await repository.getPopularTvSeries();

        // assert
        verify(mockTvSeriesRemoteDataSource.getPopularTvSeries());
        expect(
          result,
          Left(ConnectionFailure(TvSeriesRepositoryImpl.noConnectionMessage)),
        );
      },
    );
  });

  group('Get Top Rated Tv Series', () {
    test(
      'should return movie list when call to data source is successful',
      () async {
        // arrange
        when(mockTvSeriesRemoteDataSource.getTopRatedTvSeries()).thenAnswer(
          (_) async => testTvSeriesModelList,
        );

        // act
        final result = await repository.getTopRatedTvSeries();

        // assert
        final resultList = result.getOrElse(() => []);
        verify(mockTvSeriesRemoteDataSource.getTopRatedTvSeries());
        expect(resultList, testTvSeriesList);
      },
    );

    test(
      'should return server failure when call to data source is unsuccessful',
      () async {
        // arrange
        when(mockTvSeriesRemoteDataSource.getTopRatedTvSeries()).thenThrow(
          ServerException(),
        );

        // act
        final result = await repository.getTopRatedTvSeries();

        // assert
        verify(mockTvSeriesRemoteDataSource.getTopRatedTvSeries());
        expect(result, Left(ServerFailure('')));
      },
    );

    test(
      'should return connection failure when the device is not connected to internet',
      () async {
        // arrange
        when(mockTvSeriesRemoteDataSource.getTopRatedTvSeries()).thenThrow(
          SocketException(TvSeriesRepositoryImpl.noConnectionMessage),
        );

        // act
        final result = await repository.getTopRatedTvSeries();

        // assert
        verify(mockTvSeriesRemoteDataSource.getTopRatedTvSeries());
        expect(
          result,
          Left(ConnectionFailure(TvSeriesRepositoryImpl.noConnectionMessage)),
        );
      },
    );
  });

  group('Get Tv Series Detail', () {
    final testTvSeriesId = 1;
    final testTvSeriesDetailResponse = TvSeriesDetailModel(
      adult: false,
      backdropPath: 'backdropPath',
      genres: [GenreModel(id: 1, name: 'name')],
      id: 1,
      originalLanguage: 'en',
      originalName: 'originalName',
      overview: 'overview',
      popularity: 1,
      posterPath: 'posterPath',
      firstAirDate: 'firstAirDate',
      name: 'name',
      voteAverage: 1,
      voteCount: 1,
      numberOfEpisodes: 1,
      numberOfSeasons: 1,
    );

    test(
      'should return tv series detail when the call to remote data source is successful',
      () async {
        // arrange
        when(mockTvSeriesRemoteDataSource.getTvSeriesDetail(testTvSeriesId))
            .thenAnswer((_) async => testTvSeriesDetailResponse);

        // act
        final result = await repository.getTvSeriesDetail(testTvSeriesId);

        // assert
        verify(mockTvSeriesRemoteDataSource.getTvSeriesDetail(testTvSeriesId));
        expect(result, equals(Right(testTvSeriesDetail)));
      },
    );

    test(
      'should return server failure when the call to remote data source is unsuccessful',
      () async {
        // arrange
        when(mockTvSeriesRemoteDataSource.getTvSeriesDetail(testTvSeriesId))
            .thenThrow(ServerException());

        // act
        final result = await repository.getTvSeriesDetail(testTvSeriesId);

        // assert
        verify(mockTvSeriesRemoteDataSource.getTvSeriesDetail(testTvSeriesId));
        expect(result, equals(Left(ServerFailure(''))));
      },
    );

    test(
      'should return connection failure when the device is not connected to internet',
      () async {
        // arrange
        when(mockTvSeriesRemoteDataSource.getTvSeriesDetail(testTvSeriesId))
            .thenThrow(
                SocketException(TvSeriesRepositoryImpl.noConnectionMessage));

        // act
        final result = await repository.getTvSeriesDetail(testTvSeriesId);

        // assert
        verify(mockTvSeriesRemoteDataSource.getTvSeriesDetail(testTvSeriesId));
        expect(
          result,
          equals(
            Left(ConnectionFailure(TvSeriesRepositoryImpl.noConnectionMessage)),
          ),
        );
      },
    );
  });

  group('Get Tv Series Recommendations', () {
    final List<TvSeriesModel> testTvSeriesList = [];
    final testId = 1;

    test(
      'should return list recommendation tv series when the call to data source is successful',
      () async {
        // arrange
        when(mockTvSeriesRemoteDataSource.getTvSeriesRecommendations(testId))
            .thenAnswer((_) async => testTvSeriesList);

        // act
        final result = await repository.getTvSeriesRecommendations(testId);

        // assert
        final resultList = result.getOrElse(() => []);
        verify(mockTvSeriesRemoteDataSource.getTvSeriesRecommendations(testId));
        expect(resultList, equals(testTvSeriesList));
      },
    );

    test(
      'should return server failure when the call tp data source is unsuccessful',
      () async {
        // arrange
        when(mockTvSeriesRemoteDataSource.getTvSeriesRecommendations(testId))
            .thenThrow(ServerException());

        // act
        final result = await repository.getTvSeriesRecommendations(testId);

        // assert
        verify(mockTvSeriesRemoteDataSource.getTvSeriesRecommendations(testId));
        expect(result, equals(Left(ServerFailure(''))));
      },
    );

    test(
      'should return connection failure when the the device is not connected to the internet',
      () async {
        // arrange
        when(mockTvSeriesRemoteDataSource.getTvSeriesRecommendations(testId))
            .thenThrow(
                SocketException(TvSeriesRepositoryImpl.noConnectionMessage));

        // act
        final result = await repository.getTvSeriesRecommendations(testId);

        // assert
        verify(mockTvSeriesRemoteDataSource.getTvSeriesRecommendations(testId));
        expect(
          result,
          equals(
            Left(ConnectionFailure(TvSeriesRepositoryImpl.noConnectionMessage)),
          ),
        );
      },
    );
  });

  group('Search Tv Series', () {
    final testQuery = 'frieren';

    test(
      'should return searched list of tv series when call to data source is successful',
      () async {
        // arrange
        when(mockTvSeriesRemoteDataSource.searchTvSeries(testQuery)).thenAnswer(
          (_) async => testTvSeriesModelList,
        );

        // act
        final result = await repository.searchTvSeries(testQuery);

        // assert
        final resultList = result.getOrElse(() => []);
        verify(mockTvSeriesRemoteDataSource.searchTvSeries(testQuery));
        expect(resultList, testTvSeriesList);
      },
    );

    test(
      'should return server failure when call to data source is unsuccessful',
      () async {
        // arrange
        when(mockTvSeriesRemoteDataSource.searchTvSeries(testQuery)).thenThrow(
          ServerException(),
        );

        // act
        final result = await repository.searchTvSeries(testQuery);

        // assert
        verify(mockTvSeriesRemoteDataSource.searchTvSeries(testQuery));
        expect(result, equals(Left(ServerFailure(''))));
      },
    );

    test(
      'should return connection failure when the device is not connected to internet',
      () async {
        // arrange
        when(mockTvSeriesRemoteDataSource.searchTvSeries(testQuery)).thenThrow(
          SocketException(TvSeriesRepositoryImpl.noConnectionMessage),
        );

        // act
        final result = await repository.searchTvSeries(testQuery);

        // assert
        verify(mockTvSeriesRemoteDataSource.searchTvSeries(testQuery));
        expect(
          result,
          equals(
            Left(ConnectionFailure(TvSeriesRepositoryImpl.noConnectionMessage)),
          ),
        );
      },
    );
  });

  group('Save Tv Series to the Watchlist', () {
    test(
      'should return success message when saving tv series to watchlist is success',
      () async {
        // arrange
        when(mockTvSeriesLocalDataSource.insertWatchlist(testTvSeriesTable))
            .thenAnswer((_) async => 'Added tv series to watchlist');

        // act
        final result = await repository.saveWatchlistTvSeries(
          testTvSeriesDetail,
        );

        // assert
        verify(mockTvSeriesLocalDataSource.insertWatchlist(testTvSeriesTable));
        expect(result, equals(Right('Added tv series to watchlist')));
      },
    );

    test(
      'should return database failure when saving tv series to watchlist is unsuccessful',
      () async {
        // arrange
        when(mockTvSeriesLocalDataSource.insertWatchlist(testTvSeriesTable))
            .thenThrow(DatabaseException('Failed add tv series to watchlist'));

        // act
        final result = await repository.saveWatchlistTvSeries(
          testTvSeriesDetail,
        );

        // assert
        verify(mockTvSeriesLocalDataSource.insertWatchlist(testTvSeriesTable));
        expect(
          result,
          equals(
            Left(DatabaseFailure('Failed add tv series to watchlist')),
          ),
        );
      },
    );
  });

  group('Remove Tv Series to the Watchlist', () {
    test(
      'should return success message when remove tv series from watchlist is success',
      () async {
        // arrange
        when(mockTvSeriesLocalDataSource.removeWatchlist(testTvSeriesTable))
            .thenAnswer((_) async => 'Remove tv series from watchlist');

        // act
        final result = await repository.removeWatchlistTvSeries(
          testTvSeriesDetail,
        );

        // assert
        verify(mockTvSeriesLocalDataSource.removeWatchlist(testTvSeriesTable));
        expect(result, equals(Right('Remove tv series from watchlist')));
      },
    );

    test(
      'should return database failure when remove tv series from watchlist is unsuccessful',
      () async {
        // arrange
        when(mockTvSeriesLocalDataSource.removeWatchlist(testTvSeriesTable))
            .thenThrow(
                DatabaseException('Failed remove tv series from watchlist'));

        // act
        final result = await repository.removeWatchlistTvSeries(
          testTvSeriesDetail,
        );

        // assert
        verify(mockTvSeriesLocalDataSource.removeWatchlist(testTvSeriesTable));
        expect(
          result,
          equals(
            Left(DatabaseFailure('Failed remove tv series from watchlist')),
          ),
        );
      },
    );
  });

  group('Get Tv Series Watchlist Status', () {
    test(
      'should return watchlist status whether data is found',
      () async {
        // arrange
        final testId = 1;
        when(mockTvSeriesLocalDataSource.getTvSeriesDetail(testId)).thenAnswer(
          (_) async => null,
        );

        // act
        final result = await repository.isAddedToWatchlist(testId);

        // assert
        verify(mockTvSeriesLocalDataSource.getTvSeriesDetail(testId));
        expect(result, false);
      },
    );
  });

  group('Get Watchlist Tv Series', () {
    test('should return list of tv series', () async {
      // arrange
      when(mockTvSeriesLocalDataSource.getWatchlistTvSeries()).thenAnswer(
        (_) async => [testTvSeriesTable],
      );

      // act
      final result = await repository.getWatchlistTvSeries();

      // assert
      final resultList = result.getOrElse(() => []);
      verify(mockTvSeriesLocalDataSource.getWatchlistTvSeries());
      expect(resultList, [testWatchtlistTvSeries]);
    });
  });
}
