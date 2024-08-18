import 'dart:convert';

import 'package:ditonton/common/exception.dart';
import 'package:ditonton/data/datasources/tv_series_remote_data_source.dart';
import 'package:ditonton/data/models/tv_series_detail_model.dart';
import 'package:ditonton/data/models/tv_series_response.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:mockito/mockito.dart';

import '../../helpers/test_helper.mocks.dart';
import '../../json_reader.dart';

void main() {
  const API_KEY = 'api_key=2174d146bb9c0eab47529b2e77d6b526';
  const BASE_URL = 'https://api.themoviedb.org/3';

  late TvSeriesRemoteDataSourceImpl dataSource;
  late MockHttpClient mockHttpClient;

  setUp(() {
    mockHttpClient = MockHttpClient();
    dataSource = TvSeriesRemoteDataSourceImpl(client: mockHttpClient);
  });

  group('Get Airing Tv Series', () {
    final jsonFilePath = 'dummy_data/airing_tv_series.json';
    final url = '$BASE_URL/tv/airing_today?$API_KEY';
    final testTvSeriesList = TvSeriesResponse.fromJson(
      json.decode(readJson(jsonFilePath)),
    ).tvSeriesList;

    test(
      'should return list of TvSeries Model when the response code is 200',
      () async {
        // arrange
        when(mockHttpClient.get(Uri.parse(url))).thenAnswer(
          (_) async => Response(readJson(jsonFilePath), 200),
        );

        // act
        final result = await dataSource.getAiringTvSeries();

        // assert
        expect(result, equals(testTvSeriesList));
      },
    );

    test(
      'should throw a ServerException when the response code is 404 or other',
      () async {
        // arrange
        when(mockHttpClient.get(Uri.parse(url))).thenAnswer(
          (_) async => Response('Not Found', 404),
        );

        // act
        final call = dataSource.getAiringTvSeries();

        // assert
        expect(() => call, throwsA(isA<ServerException>()));
      },
    );
  });

  group('Get Popular Tv Series', () {
    final jsonFilePath = 'dummy_data/popular_tv_series.json';
    final url = '$BASE_URL/tv/popular?$API_KEY';
    final testTvSeriesList = TvSeriesResponse.fromJson(
      json.decode(readJson(jsonFilePath)),
    ).tvSeriesList;

    test(
      'should return list of TvSeries Model when the response code is 200',
      () async {
        // arrange
        when(mockHttpClient.get(Uri.parse(url))).thenAnswer(
          (_) async => Response(readJson(jsonFilePath), 200),
        );

        // act
        final result = await dataSource.getPopularTvSeries();

        // assert
        expect(result, equals(testTvSeriesList));
      },
    );

    test(
      'should throw a ServerException when the response code is 404 or other',
      () async {
        // arrange
        when(mockHttpClient.get(Uri.parse(url))).thenAnswer(
          (_) async => Response('Not Found', 404),
        );

        // act
        final call = dataSource.getPopularTvSeries();

        // assert
        expect(() => call, throwsA(isA<ServerException>()));
      },
    );
  });

  group('Get Top Rated Tv Series', () {
    final jsonFilePath = 'dummy_data/top_rated_tv_series.json';
    final url = '$BASE_URL/tv/top_rated?$API_KEY';
    final testTvSeriesList = TvSeriesResponse.fromJson(
      json.decode(readJson(jsonFilePath)),
    ).tvSeriesList;

    test(
      'should return list of TvSeries Model when the response code is 200',
      () async {
        // arrange
        when(mockHttpClient.get(Uri.parse(url))).thenAnswer(
          (_) async => Response(readJson(jsonFilePath), 200),
        );

        // act
        final result = await dataSource.getTopRatedTvSeries();

        // assert
        expect(result, equals(testTvSeriesList));
      },
    );

    test(
      'should throw a ServerException when the response code is 404 or other',
      () async {
        // arrange
        when(mockHttpClient.get(Uri.parse(url))).thenAnswer(
          (_) async => Response('Not Found', 404),
        );

        // act
        final call = dataSource.getTopRatedTvSeries();

        // assert
        expect(() => call, throwsA(isA<ServerException>()));
      },
    );
  });

  group('Get Recommendations Tv Series', () {
    final testId = 1;
    final jsonFilePath = 'dummy_data/tv_series_recommendations.json';
    final url = '$BASE_URL/tv/$testId/recommendations?$API_KEY';
    final testTvSeriesList = TvSeriesResponse.fromJson(
      json.decode(readJson(jsonFilePath)),
    ).tvSeriesList;

    test(
      'should return list of TvSeries Model when the response code is 200',
      () async {
        // arrange
        when(mockHttpClient.get(Uri.parse(url))).thenAnswer(
          (_) async => Response(readJson(jsonFilePath), 200),
        );

        // act
        final result = await dataSource.getTvSeriesRecommendations(testId);

        // assert
        expect(result, equals(testTvSeriesList));
      },
    );

    test(
      'should throw a ServerException when the response code is 404 or other',
      () async {
        // arrange
        when(mockHttpClient.get(Uri.parse(url))).thenAnswer(
          (_) async => Response('Not Found', 404),
        );

        // act
        final call = dataSource.getTvSeriesRecommendations(testId);

        // assert
        expect(() => call, throwsA(isA<ServerException>()));
      },
    );
  });

  group('Get Tv Series Detail', () {
    final testId = 1;
    final jsonFilePath = 'dummy_data/tv_series_detail.json';
    final url = '$BASE_URL/tv/$testId?$API_KEY';
    final testTvSeriesList = TvSeriesDetailModel.fromJson(
      json.decode(readJson(jsonFilePath)),
    );

    test(
      'should return list of TvSeries Model when the response code is 200',
      () async {
        // arrange
        when(mockHttpClient.get(Uri.parse(url))).thenAnswer(
          (_) async => Response(readJson(jsonFilePath), 200),
        );

        // act
        final result = await dataSource.getTvSeriesDetail(testId);

        // assert
        expect(result, equals(testTvSeriesList));
      },
    );

    test(
      'should throw a ServerException when the response code is 404 or other',
      () async {
        // arrange
        when(mockHttpClient.get(Uri.parse(url))).thenAnswer(
          (_) async => Response('Not Found', 404),
        );

        // act
        final call = dataSource.getTvSeriesDetail(testId);

        // assert
        expect(() => call, throwsA(isA<ServerException>()));
      },
    );
  });

  group('Search Tv Series', () {
    final query = 'cacau';
    final jsonFilePath = 'dummy_data/search_tv_series.json';
    final url = '$BASE_URL/search/tv?$API_KEY&query=$query';
    final testTvSeriesList = TvSeriesResponse.fromJson(
      json.decode(readJson(jsonFilePath)),
    ).tvSeriesList;

    test(
      'should return list of TvSeries Model when the response code is 200',
      () async {
        // arrange
        when(mockHttpClient.get(Uri.parse(url))).thenAnswer(
          (_) async => Response(readJson(jsonFilePath), 200),
        );

        // act
        final result = await dataSource.searchTvSeries(query);

        // assert
        expect(result, equals(testTvSeriesList));
      },
    );

    test(
      'should throw a ServerException when the response code is 404 or other',
      () async {
        // arrange
        when(mockHttpClient.get(Uri.parse(url))).thenAnswer(
          (_) async => Response('Not Found', 404),
        );

        // act
        final call = dataSource.searchTvSeries(query);

        // assert
        expect(() => call, throwsA(isA<ServerException>()));
      },
    );
  });
}
