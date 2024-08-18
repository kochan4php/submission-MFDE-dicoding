import 'package:cached_network_image/cached_network_image.dart';
import 'package:ditonton/common/constants.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/presentation/pages/movie_detail_page.dart';
import 'package:ditonton/presentation/pages/popular_movies_page.dart';
import 'package:ditonton/presentation/pages/search_page.dart';
import 'package:ditonton/presentation/pages/top_rated_movies_page.dart';
import 'package:ditonton/presentation/provider/movie_list_notifier.dart';
import 'package:ditonton/presentation/widgets/custom_drawer.dart';
import 'package:ditonton/presentation/widgets/sub_heading.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class HomeMoviePage extends StatefulWidget {
  static const ROUTE_NAME = '/home';

  @override
  _HomeMoviePageState createState() => _HomeMoviePageState();
}

class _HomeMoviePageState extends State<HomeMoviePage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => Provider.of<MovieListNotifier>(context, listen: false)
        ..fetchNowPlayingMovies()
        ..fetchPopularMovies()
        ..fetchTopRatedMovies(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomDrawer(),
      appBar: AppBar(
        title: Text('Ditonton'),
        actions: [
          IconButton(
            onPressed: () => Navigator.pushNamed(
              context,
              SearchPage.ROUTE_NAME,
              arguments: true,
            ),
            icon: Icon(Icons.search),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text('Now Playing', style: kHeading6),
              ),
              const SizedBox(height: 5),
              Consumer<MovieListNotifier>(
                builder: (context, data, child) {
                  final state = data.nowPlayingState;

                  if (state == RequestState.Loading) {
                    return Center(child: CircularProgressIndicator());
                  } else if (state == RequestState.Loaded) {
                    return MovieList(data.nowPlayingMovies);
                  } else {
                    return Text('Failed');
                  }
                },
              ),
              const SizedBox(height: 10),
              SubHeading(
                title: 'Popular',
                onTap: () => Navigator.pushNamed(
                  context,
                  PopularMoviesPage.ROUTE_NAME,
                ),
              ),
              Consumer<MovieListNotifier>(
                builder: (context, data, child) {
                  final state = data.popularMoviesState;

                  if (state == RequestState.Loading) {
                    return Center(child: CircularProgressIndicator());
                  } else if (state == RequestState.Loaded) {
                    return MovieList(data.popularMovies);
                  } else {
                    return Text('Failed');
                  }
                },
              ),
              const SizedBox(height: 10),
              SubHeading(
                title: 'Top Rated',
                onTap: () => Navigator.pushNamed(
                  context,
                  TopRatedMoviesPage.ROUTE_NAME,
                ),
              ),
              Consumer<MovieListNotifier>(builder: (context, data, child) {
                final state = data.topRatedMoviesState;

                if (state == RequestState.Loading) {
                  return Center(child: CircularProgressIndicator());
                } else if (state == RequestState.Loaded) {
                  return MovieList(data.topRatedMovies);
                } else {
                  return Text('Failed');
                }
              }),
            ],
          ),
        ),
      ),
    );
  }
}

class MovieList extends StatelessWidget {
  final List<Movie> movies;

  MovieList(this.movies);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final movie = movies[index];
          return Container(
            padding: const EdgeInsets.all(8),
            child: InkWell(
              onTap: () => Navigator.pushNamed(
                context,
                MovieDetailPage.ROUTE_NAME,
                arguments: movie.id,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(16)),
                child: CachedNetworkImage(
                  imageUrl: '$BASE_IMAGE_URL${movie.posterPath}',
                  width: 120,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Shimmer.fromColors(
                    baseColor: Colors.grey[700]!,
                    highlightColor: Colors.grey[500]!,
                    enabled: true,
                    child: Container(height: 120, color: Colors.grey),
                  ),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              ),
            ),
          );
        },
        itemCount: movies.length,
      ),
    );
  }
}
