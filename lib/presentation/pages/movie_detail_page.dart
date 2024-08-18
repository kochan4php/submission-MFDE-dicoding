import 'package:cached_network_image/cached_network_image.dart';
import 'package:ditonton/common/constants.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/genre.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/entities/movie_detail.dart';
import 'package:ditonton/presentation/provider/movie_detail_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class MovieDetailPage extends StatefulWidget {
  static const ROUTE_NAME = '/detail';

  final int id;
  MovieDetailPage({required this.id});

  @override
  _MovieDetailPageState createState() => _MovieDetailPageState();
}

class _MovieDetailPageState extends State<MovieDetailPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<MovieDetailNotifier>(context, listen: false)
        ..fetchMovieDetail(widget.id)
        ..loadWatchlistStatus(widget.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<MovieDetailNotifier>(
        builder: (context, provider, child) {
          final state = provider.movieState;

          if (state == RequestState.Loading) {
            return Center(child: CircularProgressIndicator());
          } else if (state == RequestState.Loaded) {
            final movie = provider.movie;

            return SafeArea(
              child: DetailContent(
                movie,
                provider.movieRecommendations,
                provider.isAddedToWatchlist,
              ),
            );
          } else {
            return Text(provider.message);
          }
        },
      ),
    );
  }
}

class DetailContent extends StatelessWidget {
  final MovieDetail movie;
  final List<Movie> recommendations;
  final bool isAddedWatchlist;

  DetailContent(this.movie, this.recommendations, this.isAddedWatchlist);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Stack(
      children: [
        CachedNetworkImage(
          imageUrl: 'https://image.tmdb.org/t/p/w500${movie.posterPath}',
          width: screenWidth,
          placeholder: (context, url) => Center(
            child: CircularProgressIndicator(),
          ),
          errorWidget: (context, url, error) => Icon(Icons.error),
        ),
        Container(
          margin: const EdgeInsets.only(top: 48 + 8),
          child: DraggableScrollableSheet(
            snap: true,
            builder: (context, scrollController) {
              return Container(
                decoration: BoxDecoration(
                  color: kRichBlack,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                ),
                padding: const EdgeInsets.only(left: 16, top: 16, right: 16),
                child: Stack(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 16),
                      child: SingleChildScrollView(
                        controller: scrollController,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(movie.title, style: kHeading5),
                            _buildWatchlistButton(context),
                            Text(_showGenres(movie.genres)),
                            Text(_showDuration(movie.runtime)),
                            Row(
                              children: [
                                RatingBarIndicator(
                                  rating: movie.voteAverage / 2,
                                  itemCount: 5,
                                  itemBuilder: (context, index) => Icon(
                                    Icons.star,
                                    color: kMikadoYellow,
                                  ),
                                  itemSize: 24,
                                ),
                                Text('${movie.voteAverage}')
                              ],
                            ),
                            SizedBox(height: 16),
                            Text('Overview', style: kHeading6),
                            Text(movie.overview),
                            SizedBox(height: 16),
                            Text('Recommendations', style: kHeading6),
                            _buildRecommendationMovies(),
                          ],
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        color: Colors.white,
                        height: 4,
                        width: 48,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: kRichBlack,
            foregroundColor: Colors.white,
            child: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        )
      ],
    );
  }

  Consumer<MovieDetailNotifier> _buildRecommendationMovies() {
    return Consumer<MovieDetailNotifier>(
      builder: (context, data, child) {
        final state = data.recommendationState;

        if (state == RequestState.Loading) {
          return Center(child: CircularProgressIndicator());
        } else if (state == RequestState.Error) {
          return Text(data.message);
        } else if (state == RequestState.Loaded) {
          return Container(
            height: 200,
            margin: const EdgeInsets.only(top: 10),
            child: ListView.separated(
              separatorBuilder: (context, index) => const SizedBox(width: 15),
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                final movie = recommendations[index];
                final posterPath =
                    'https://image.tmdb.org/t/p/w500${movie.posterPath}';

                return Padding(
                  padding: const EdgeInsets.all(0),
                  child: GestureDetector(
                    onTap: () => Navigator.pushReplacementNamed(
                      context,
                      MovieDetailPage.ROUTE_NAME,
                      arguments: movie.id,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                      child: CachedNetworkImage(
                        width: 120,
                        fit: BoxFit.cover,
                        imageUrl: posterPath,
                        placeholder: (context, url) => Shimmer.fromColors(
                          baseColor: Colors.grey[700]!,
                          highlightColor: Colors.grey[500]!,
                          enabled: true,
                          child: Container(height: 130, color: Colors.grey),
                        ),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      ),
                    ),
                  ),
                );
              },
              itemCount: recommendations.length,
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }

  ElevatedButton _buildWatchlistButton(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: kMikadoYellow,
        foregroundColor: kRichBlack,
      ),
      onPressed: () async {
        final notifier = Provider.of<MovieDetailNotifier>(
          context,
          listen: false,
        );

        if (!isAddedWatchlist) {
          await notifier.addWatchlist(movie);
        } else {
          await notifier.removeFromWatchlist(movie);
        }

        final message = notifier.watchlistMessage;

        if (message == MovieDetailNotifier.watchlistAddSuccessMessage ||
            message == MovieDetailNotifier.watchlistRemoveSuccessMessage) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(message)),
          );
        } else {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              content: Text(message),
            ),
          );
        }
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          isAddedWatchlist ? Icon(Icons.check) : Icon(Icons.add),
          Text('Watchlist'),
        ],
      ),
    );
  }

  String _showGenres(List<Genre> genres) {
    String result = '';
    for (var genre in genres) {
      result += genre.name + ', ';
    }

    if (result.isEmpty) {
      return result;
    }

    return result.substring(0, result.length - 2);
  }

  String _showDuration(int runtime) {
    final int hours = runtime ~/ 60;
    final int minutes = runtime % 60;

    if (hours > 0) {
      return '${hours}h ${minutes}m';
    } else {
      return '${minutes}m';
    }
  }
}
