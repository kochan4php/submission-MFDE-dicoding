import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:ditonton/presentation/pages/popular_tv_series_page.dart';
import 'package:ditonton/presentation/provider/popular_tv_series_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

import 'popular_tv_series_page_test.mocks.dart';

@GenerateMocks([PopularTvSeriesNotifier])
void main() {
  late MockPopularTvSeriesNotifier mockPopularTvSeriesNotifier;

  setUp(() {
    mockPopularTvSeriesNotifier = MockPopularTvSeriesNotifier();
  });

  Widget _makeTestableWidget(Widget body) {
    return ChangeNotifierProvider<PopularTvSeriesNotifier>.value(
      value: mockPopularTvSeriesNotifier,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  testWidgets(
    'Page should display progress bar when loading',
    (WidgetTester tester) async {
      when(mockPopularTvSeriesNotifier.fetchPopularTvSeries()).thenAnswer(
        (_) async => null,
      );

      when(mockPopularTvSeriesNotifier.popularTvSeriesState).thenReturn(
        RequestState.Loading,
      );

      final progressFinder = find.byType(CircularProgressIndicator);
      final centerFinder = find.byType(Center);

      await tester.pumpWidget(_makeTestableWidget(PopularTvSeriesPage()));

      expect(centerFinder, findsOneWidget);
      expect(progressFinder, findsOneWidget);
    },
  );

  testWidgets(
    'Page should display when data is loaded',
    (WidgetTester tester) async {
      when(mockPopularTvSeriesNotifier.fetchPopularTvSeries()).thenAnswer(
        (_) async => null,
      );

      when(mockPopularTvSeriesNotifier.popularTvSeriesState).thenReturn(
        RequestState.Loaded,
      );

      when(mockPopularTvSeriesNotifier.popularTvSeries).thenReturn(
        <TvSeries>[],
      );

      final listViewFinder = find.byType(ListView);

      await tester.pumpWidget(_makeTestableWidget(PopularTvSeriesPage()));

      expect(listViewFinder, findsOneWidget);
    },
  );

  testWidgets(
    'Page should display text with message when Error',
    (WidgetTester tester) async {
      when(mockPopularTvSeriesNotifier.fetchPopularTvSeries()).thenAnswer(
        (_) async => null,
      );

      when(mockPopularTvSeriesNotifier.popularTvSeriesState).thenReturn(
        RequestState.Error,
      );

      when(mockPopularTvSeriesNotifier.message).thenReturn('Error message');

      final textFinder = find.byKey(Key('error_message'));

      await tester.pumpWidget(_makeTestableWidget(PopularTvSeriesPage()));

      expect(textFinder, findsOneWidget);
    },
  );
}
