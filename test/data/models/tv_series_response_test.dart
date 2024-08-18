import 'dart:convert';

import 'package:ditonton/data/models/tv_series_model.dart';
import 'package:ditonton/data/models/tv_series_response.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../json_reader.dart';

void main() {
  final testTvSeriesModel = TvSeriesModel(
    adult: false,
    backdropPath: "/9faGSFi5jam6pDWGNd0p8JcJgXQ.jpg",
    genreIds: [18, 80],
    id: 1396,
    originCountry: ["US"],
    originalLanguage: 'en',
    originalName: 'Breaking Bad',
    overview:
        "Walter White, a New Mexico chemistry teacher, is diagnosed with Stage III cancer and given a prognosis of only two years left to live. He becomes filled with a sense of fearlessness and an unrelenting desire to secure his family's financial future at any cost as he enters the dangerous world of drugs and crime.",
    popularity: 518.275,
    posterPath: '/ztkUQFLlC19CCMYHW9o1zWhJRNq.jpg',
    firstAirDate: '2008-01-20',
    name: 'Breaking Bad',
    voteAverage: 8.913,
    voteCount: 14002,
  );

  final testTvSeriesResponse = TvSeriesResponse(
    tvSeriesList: [testTvSeriesModel],
  );

  group('fromJson method', () {
    test('should return a valid model from JSON', () {
      // arrange
      final jsonMap = json.decode(
        readJson('dummy_data/top_rated_tv_series.json'),
      );

      // act
      final result = TvSeriesResponse.fromJson(jsonMap);

      // assert
      expect(result, testTvSeriesResponse);
    });
  });

  group('toJson method', () {
    test(
      'should return a JSON map containing proper data',
      () async {
        // act
        final result = testTvSeriesResponse.toJson();

        // assert
        final expectedJsonMap = {
          'results': [
            {
              "adult": false,
              "backdrop_path": "/9faGSFi5jam6pDWGNd0p8JcJgXQ.jpg",
              "genre_ids": [18, 80],
              "id": 1396,
              "origin_country": ["US"],
              "original_language": "en",
              "original_name": "Breaking Bad",
              "overview":
                  "Walter White, a New Mexico chemistry teacher, is diagnosed with Stage III cancer and given a prognosis of only two years left to live. He becomes filled with a sense of fearlessness and an unrelenting desire to secure his family's financial future at any cost as he enters the dangerous world of drugs and crime.",
              "popularity": 518.275,
              "poster_path": "/ztkUQFLlC19CCMYHW9o1zWhJRNq.jpg",
              "first_air_date": "2008-01-20",
              "name": "Breaking Bad",
              "vote_average": 8.913,
              "vote_count": 14002
            }
          ],
        };

        expect(result, expectedJsonMap);
      },
    );
  });
}
