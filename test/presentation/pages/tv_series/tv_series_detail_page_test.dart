import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:ditonton/presentation/pages/tv_series_detail_page.dart';
import 'package:ditonton/presentation/provider/tv_series_detail_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

import '../../../dummy_data/dummy_objects.dart';
import 'tv_series_detail_page_test.mocks.dart';

@GenerateMocks([TvSeriesDetailNotifier])
void main() {
  late MockTvSeriesDetailNotifier mockTvSeriesDetailNotifier;

  setUp(() {
    mockTvSeriesDetailNotifier = MockTvSeriesDetailNotifier();

    when(mockTvSeriesDetailNotifier.fetchTvSeriesDetail(1))
        .thenAnswer((_) async => null);

    when(mockTvSeriesDetailNotifier.addWatchlist(testTvSeriesDetail))
        .thenAnswer((_) async => null);

    when(mockTvSeriesDetailNotifier.removeWatchlist(testTvSeriesDetail))
        .thenAnswer((_) async => null);

    when(mockTvSeriesDetailNotifier.loadTvSeriesWatchlistStatus(1))
        .thenAnswer((_) async => null);
  });

  Widget _makeTestableWidget(Widget body) {
    return ChangeNotifierProvider<TvSeriesDetailNotifier>.value(
      value: mockTvSeriesDetailNotifier,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  testWidgets(
    'Watchlist button should display add icon when not added to watchlist',
    (WidgetTester tester) async {
      when(mockTvSeriesDetailNotifier.tvSeriesState)
          .thenReturn(RequestState.Loaded);

      when(mockTvSeriesDetailNotifier.tvSeriesDetail)
          .thenReturn(testTvSeriesDetail);

      when(mockTvSeriesDetailNotifier.recommendationState)
          .thenReturn(RequestState.Loaded);

      when(mockTvSeriesDetailNotifier.tvSeriesRecommendation)
          .thenReturn(<TvSeries>[]);

      when(mockTvSeriesDetailNotifier.isAddedToWatchlist).thenReturn(false);

      final watchlistButtonIcon = find.byIcon(Icons.add);

      await tester.pumpWidget(_makeTestableWidget(TvSeriesDetailPage(
        id: 1,
      )));

      expect(watchlistButtonIcon, findsOneWidget);
    },
  );

  testWidgets(
    'Watchlist button should display check icon when added to watchlist',
    (WidgetTester tester) async {
      when(mockTvSeriesDetailNotifier.tvSeriesState)
          .thenReturn(RequestState.Loaded);

      when(mockTvSeriesDetailNotifier.tvSeriesDetail)
          .thenReturn(testTvSeriesDetail);

      when(mockTvSeriesDetailNotifier.recommendationState)
          .thenReturn(RequestState.Loaded);

      when(mockTvSeriesDetailNotifier.tvSeriesRecommendation)
          .thenReturn(<TvSeries>[]);

      when(mockTvSeriesDetailNotifier.isAddedToWatchlist).thenReturn(true);

      final watchlistButtonIcon = find.byIcon(Icons.check);

      await tester.pumpWidget(_makeTestableWidget(TvSeriesDetailPage(
        id: 1,
      )));

      expect(watchlistButtonIcon, findsOneWidget);
    },
  );

  testWidgets(
    'Watchlist button should display Snackbar when added to watchlist',
    (WidgetTester tester) async {
      when(mockTvSeriesDetailNotifier.tvSeriesState)
          .thenReturn(RequestState.Loaded);

      when(mockTvSeriesDetailNotifier.tvSeriesDetail)
          .thenReturn(testTvSeriesDetail);

      when(mockTvSeriesDetailNotifier.recommendationState)
          .thenReturn(RequestState.Loaded);

      when(mockTvSeriesDetailNotifier.tvSeriesRecommendation)
          .thenReturn(<TvSeries>[]);

      when(mockTvSeriesDetailNotifier.isAddedToWatchlist).thenReturn(true);

      when(mockTvSeriesDetailNotifier.watchlistMessage)
          .thenReturn('Added tv series to watchlist');

      final watchlistButtonIcon = find.byType(ElevatedButton);

      await tester.pumpWidget(_makeTestableWidget(TvSeriesDetailPage(
        id: 1,
      )));

      expect(find.byIcon(Icons.check), findsOneWidget);

      await tester.tap(watchlistButtonIcon);
      await tester.pump();

      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.text('Added tv series to watchlist'), findsOneWidget);
    },
  );

  testWidgets(
    'Watchlist button should display AlertDialog when add to watchlist failed',
    (WidgetTester tester) async {
      when(mockTvSeriesDetailNotifier.tvSeriesState)
          .thenReturn(RequestState.Loaded);

      when(mockTvSeriesDetailNotifier.tvSeriesDetail)
          .thenReturn(testTvSeriesDetail);

      when(mockTvSeriesDetailNotifier.recommendationState)
          .thenReturn(RequestState.Loaded);

      when(mockTvSeriesDetailNotifier.tvSeriesRecommendation)
          .thenReturn(<TvSeries>[]);

      when(mockTvSeriesDetailNotifier.isAddedToWatchlist).thenReturn(false);

      when(mockTvSeriesDetailNotifier.watchlistMessage).thenReturn('Failed');

      final watchlistButtonIcon = find.byType(ElevatedButton);

      await tester.pumpWidget(_makeTestableWidget(TvSeriesDetailPage(
        id: 1,
      )));

      expect(find.byIcon(Icons.add), findsOneWidget);

      await tester.tap(watchlistButtonIcon);
      await tester.pump();

      expect(find.byType(AlertDialog), findsOneWidget);
      expect(find.text('Failed'), findsOneWidget);
    },
  );
}
