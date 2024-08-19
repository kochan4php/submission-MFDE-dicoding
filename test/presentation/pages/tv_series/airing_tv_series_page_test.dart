import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:ditonton/presentation/pages/airing_tv_series_page.dart';
import 'package:ditonton/presentation/provider/airing_tv_series_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

import 'airing_tv_series_page_test.mocks.dart';

@GenerateMocks([AiringTvSeriesNotifier])
void main() {
  late MockAiringTvSeriesNotifier mockAiringTvSeriesNotifier;

  setUp(() {
    mockAiringTvSeriesNotifier = MockAiringTvSeriesNotifier();
  });

  Widget _makeTestableWidget(Widget body) {
    return ChangeNotifierProvider<AiringTvSeriesNotifier>.value(
      value: mockAiringTvSeriesNotifier,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  testWidgets(
    'Page should display progress bar when loading',
    (WidgetTester tester) async {
      when(mockAiringTvSeriesNotifier.fetchAiringTvSeries()).thenAnswer(
        (_) async => null,
      );

      when(mockAiringTvSeriesNotifier.airingState).thenReturn(
        RequestState.Loading,
      );

      final progressFinder = find.byType(CircularProgressIndicator);
      final centerFinder = find.byType(Center);

      await tester.pumpWidget(_makeTestableWidget(AiringTvSeriesPage()));

      expect(centerFinder, findsOneWidget);
      expect(progressFinder, findsOneWidget);
    },
  );

  testWidgets(
    'Page should display when data is loaded',
    (WidgetTester tester) async {
      when(mockAiringTvSeriesNotifier.fetchAiringTvSeries()).thenAnswer(
        (_) async => null,
      );

      when(mockAiringTvSeriesNotifier.airingState).thenReturn(
        RequestState.Loaded,
      );

      when(mockAiringTvSeriesNotifier.airingTvSeries).thenReturn(
        <TvSeries>[],
      );

      final listViewFinder = find.byType(ListView);

      await tester.pumpWidget(_makeTestableWidget(AiringTvSeriesPage()));

      expect(listViewFinder, findsOneWidget);
    },
  );

  testWidgets(
    'Page should display text with message when Error',
    (WidgetTester tester) async {
      when(mockAiringTvSeriesNotifier.fetchAiringTvSeries()).thenAnswer(
        (_) async => null,
      );

      when(mockAiringTvSeriesNotifier.airingState).thenReturn(
        RequestState.Error,
      );

      when(mockAiringTvSeriesNotifier.message).thenReturn('Error message');

      final textFinder = find.byKey(Key('error_message'));

      await tester.pumpWidget(_makeTestableWidget(AiringTvSeriesPage()));

      expect(textFinder, findsOneWidget);
    },
  );
}
