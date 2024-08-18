import 'package:ditonton/common/constants.dart';
import 'package:ditonton/common/utils.dart';
import 'package:ditonton/injection.dart' as di;
import 'package:ditonton/presentation/pages/about_page.dart';
import 'package:ditonton/presentation/pages/home_movie_page.dart';
import 'package:ditonton/presentation/pages/movie_detail_page.dart';
import 'package:ditonton/presentation/pages/popular_movies_page.dart';
import 'package:ditonton/presentation/pages/popular_tv_series_page.dart';
import 'package:ditonton/presentation/pages/search_page.dart';
import 'package:ditonton/presentation/pages/top_rated_movies_page.dart';
import 'package:ditonton/presentation/pages/top_rated_tv_series_page.dart';
import 'package:ditonton/presentation/pages/tv_series_detail_page.dart';
import 'package:ditonton/presentation/pages/tv_series_list_page.dart';
import 'package:ditonton/presentation/pages/watchlist_movies_page.dart';
import 'package:ditonton/presentation/pages/watchlist_page.dart';
import 'package:ditonton/presentation/pages/watchlist_tv_series_page.dart';
import 'package:ditonton/presentation/provider/movie_detail_notifier.dart';
import 'package:ditonton/presentation/provider/movie_list_notifier.dart';
import 'package:ditonton/presentation/provider/movie_search_notifier.dart';
import 'package:ditonton/presentation/provider/popular_movies_notifier.dart';
import 'package:ditonton/presentation/provider/popular_tv_series_notifier.dart';
import 'package:ditonton/presentation/provider/top_rated_movies_notifier.dart';
import 'package:ditonton/presentation/provider/top_rated_tv_series_notifier.dart';
import 'package:ditonton/presentation/provider/tv_series_detail_notifier.dart';
import 'package:ditonton/presentation/provider/tv_series_list_notifier.dart';
import 'package:ditonton/presentation/provider/tv_series_search_notifier.dart';
import 'package:ditonton/presentation/provider/watchlist_movie_notifier.dart';
import 'package:ditonton/presentation/provider/watchlist_tv_series_notifier.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  di.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final providers = [
      ChangeNotifierProvider(
        create: (_) => di.locator<MovieListNotifier>(),
      ),
      ChangeNotifierProvider(
        create: (_) => di.locator<MovieDetailNotifier>(),
      ),
      ChangeNotifierProvider(
        create: (_) => di.locator<MovieSearchNotifier>(),
      ),
      ChangeNotifierProvider(
        create: (_) => di.locator<TopRatedMoviesNotifier>(),
      ),
      ChangeNotifierProvider(
        create: (_) => di.locator<PopularMoviesNotifier>(),
      ),
      ChangeNotifierProvider(
        create: (_) => di.locator<WatchlistMovieNotifier>(),
      ),
      ChangeNotifierProvider(
        create: (_) => di.locator<TvSeriesListNotifier>(),
      ),
      ChangeNotifierProvider(
        create: (_) => di.locator<TvSeriesDetailNotifier>(),
      ),
      ChangeNotifierProvider(
        create: (_) => di.locator<TopRatedTvSeriesNotifier>(),
      ),
      ChangeNotifierProvider(
        create: (_) => di.locator<PopularTvSeriesNotifier>(),
      ),
      ChangeNotifierProvider(
        create: (_) => di.locator<TvSeriesSearchNotifier>(),
      ),
      ChangeNotifierProvider(
        create: (_) => di.locator<WatchlistTvSeriesNotifier>(),
      ),
    ];

    return MultiProvider(
      providers: providers,
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData.dark().copyWith(
          colorScheme: kColorScheme,
          primaryColor: kRichBlack,
          scaffoldBackgroundColor: kRichBlack,
          textTheme: kTextTheme,
        ),
        debugShowCheckedModeBanner: false,
        home: HomeMoviePage(),
        navigatorObservers: [routeObserver],
        onGenerateRoute: _routeMapping,
      ),
    );
  }

  Route<dynamic>? _routeMapping(RouteSettings settings) {
    switch (settings.name) {
      // movie
      case HomeMoviePage.ROUTE_NAME:
        return MaterialPageRoute(builder: (_) => HomeMoviePage());
      case PopularMoviesPage.ROUTE_NAME:
        return CupertinoPageRoute(builder: (_) => PopularMoviesPage());
      case TopRatedMoviesPage.ROUTE_NAME:
        return CupertinoPageRoute(builder: (_) => TopRatedMoviesPage());
      case MovieDetailPage.ROUTE_NAME:
        final id = settings.arguments as int;

        return CupertinoPageRoute(
          builder: (_) => MovieDetailPage(id: id),
          settings: settings,
        );
      case WatchlistMoviesPage.ROUTE_NAME:
        return CupertinoPageRoute(builder: (_) => WatchlistMoviesPage());

      // tv series
      case TvSeriesListPage.ROUTE_NAME:
        return MaterialPageRoute(builder: (_) => TvSeriesListPage());
      case PopularTvSeriesPage.ROUTE_NAME:
        return CupertinoPageRoute(builder: (_) => PopularTvSeriesPage());
      case TopRatedTvSeriesPage.ROUTE_NAME:
        return CupertinoPageRoute(builder: (_) => TopRatedTvSeriesPage());
      case TvSeriesDetailPage.ROUTE_NAME:
        final id = settings.arguments as int;
        return CupertinoPageRoute(
          builder: (_) => TvSeriesDetailPage(id: id),
          settings: settings,
        );
      case WatchlistTvSeriesPage.ROUTE_NAME:
        return CupertinoPageRoute(builder: (_) => WatchlistTvSeriesPage());

      // search
      case SearchPage.ROUTE_NAME:
        final isMovieSearch = settings.arguments as bool;

        return MaterialPageRoute(
          builder: (_) => SearchPage(isSearchMovie: isMovieSearch),
          settings: settings,
        );

      // watchlist page
      case WatchlistPage.ROUTE_NAME:
        return MaterialPageRoute(builder: (_) => WatchlistPage());
      case AboutPage.ROUTE_NAME:
        return MaterialPageRoute(builder: (_) => AboutPage());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('Page not found :(')),
          ),
        );
    }
  }
}
