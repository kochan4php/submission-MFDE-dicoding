import 'package:ditonton/common/constants.dart';
import 'package:ditonton/common/ssl_pinning.dart';
import 'package:ditonton/common/utils.dart';
import 'package:ditonton/firebase_options.dart';
import 'package:ditonton/injection.dart' as di;
import 'package:ditonton/presentation/bloc/movies/detail_movie/detail_movie_bloc.dart';
import 'package:ditonton/presentation/bloc/movies/now_playing_movies/now_playing_movies_bloc.dart';
import 'package:ditonton/presentation/bloc/movies/popular_movies/popular_movies_bloc.dart';
import 'package:ditonton/presentation/bloc/movies/search_movies/search_bloc.dart';
import 'package:ditonton/presentation/bloc/movies/top_rated_movies/top_rated_movies_bloc.dart';
import 'package:ditonton/presentation/bloc/movies/watchlist_movies/watchlist_movies_bloc.dart';
import 'package:ditonton/presentation/bloc/tv_series/detail_tv_series/detail_tv_series_bloc.dart';
import 'package:ditonton/presentation/bloc/tv_series/popular_tv_series/popular_tv_series_bloc.dart';
import 'package:ditonton/presentation/bloc/tv_series/top_rated_tv_series/top_rated_tv_series_bloc.dart';
import 'package:ditonton/presentation/bloc/tv_series/tv_series_now_airing/tv_series_now_airing_bloc.dart';
import 'package:ditonton/presentation/bloc/tv_series/tv_series_search/tv_series_search_bloc.dart';
import 'package:ditonton/presentation/bloc/tv_series/watchlist_tv_series/watchlist_tv_series_bloc.dart';
import 'package:ditonton/presentation/pages/about_page.dart';
import 'package:ditonton/presentation/pages/airing_tv_series_page.dart';
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
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await SSLPinning.init();

  di.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final providers = [
      // movies
      BlocProvider(create: (_) => di.locator<NowPlayingMoviesBloc>()),
      BlocProvider(create: (_) => di.locator<TopRatedMoviesBloc>()),
      BlocProvider(create: (_) => di.locator<PopularMoviesBloc>()),
      BlocProvider(create: (_) => di.locator<DetailMovieBloc>()),
      BlocProvider(create: (_) => di.locator<SearchBloc>()),
      BlocProvider(create: (_) => di.locator<WatchlistMoviesBloc>()),

      // tv series
      BlocProvider(create: (_) => di.locator<TvSeriesNowAiringBloc>()),
      BlocProvider(create: (_) => di.locator<PopularTvSeriesBloc>()),
      BlocProvider(create: (_) => di.locator<TopRatedTvSeriesBloc>()),
      BlocProvider(create: (_) => di.locator<DetailTvSeriesBloc>()),
      BlocProvider(create: (_) => di.locator<TvSeriesSearchBloc>()),
      BlocProvider(create: (_) => di.locator<WatchlistTvSeriesBloc>()),
    ];

    return MultiBlocProvider(
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
      case AiringTvSeriesPage.ROUTE_NAME:
        return CupertinoPageRoute(builder: (_) => AiringTvSeriesPage());
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
