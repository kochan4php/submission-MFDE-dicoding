import 'package:cached_network_image/cached_network_image.dart';
import 'package:ditonton/common/constants.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/genre.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:ditonton/domain/entities/tv_series_detail.dart';
import 'package:ditonton/presentation/provider/tv_series_detail_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class TvSeriesDetailPage extends StatefulWidget {
  static const ROUTE_NAME = '/detail-tv-series';

  final int id;
  TvSeriesDetailPage({required this.id});

  @override
  _TvSeriesDetailPageState createState() => _TvSeriesDetailPageState();
}

class _TvSeriesDetailPageState extends State<TvSeriesDetailPage> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      Provider.of<TvSeriesDetailNotifier>(context, listen: false)
        ..fetchTvSeriesDetail(widget.id)
        ..loadTvSeriesWatchlistStatus(widget.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<TvSeriesDetailNotifier>(
        builder: (context, provider, child) {
          if (provider.tvSeriesState == RequestState.Loading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (provider.tvSeriesState == RequestState.Loaded) {
            final tvSeries = provider.tvSeriesDetail;
            return SafeArea(
              child: DetailContent(
                tvSeries,
                provider.tvSeriesRecommendation,
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
  final TvSeriesDetail tvSeries;
  final List<TvSeries> tvSeriesRecommendations;
  final bool isAddedWatchlist;

  DetailContent(
    this.tvSeries,
    this.tvSeriesRecommendations,
    this.isAddedWatchlist,
  );

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Stack(
      children: [
        CachedNetworkImage(
          imageUrl: 'https://image.tmdb.org/t/p/w500${tvSeries.posterPath}',
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
                padding: const EdgeInsets.only(
                  left: 16,
                  top: 16,
                  right: 16,
                ),
                child: Stack(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 16),
                      child: SingleChildScrollView(
                        controller: scrollController,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(tvSeries.name, style: kHeading5),
                            _buildWatchlistButton(context),
                            Text(_showGenres(tvSeries.genres)),
                            Row(
                              children: [
                                RatingBarIndicator(
                                  rating: tvSeries.voteAverage / 2,
                                  itemCount: 5,
                                  itemBuilder: (context, index) => Icon(
                                    Icons.star,
                                    color: kMikadoYellow,
                                  ),
                                  itemSize: 24,
                                ),
                                Text('${tvSeries.voteAverage}')
                              ],
                            ),
                            SizedBox(height: 16),
                            Text('Overview', style: kHeading6),
                            Text(tvSeries.overview),
                            SizedBox(height: 16),
                            Text('Recommendations', style: kHeading6),
                            _buildRecommendationTvSeries(),
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
            // initialChildSize: 0.5,
            minChildSize: 0.25,
            // maxChildSize: 1.0,
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

  ElevatedButton _buildWatchlistButton(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: kMikadoYellow,
        foregroundColor: kRichBlack,
      ),
      onPressed: () async {
        final notifier = Provider.of<TvSeriesDetailNotifier>(
          context,
          listen: false,
        );

        if (!isAddedWatchlist) {
          await notifier.addWatchlist(tvSeries);
        } else {
          await notifier.removeWatchlist(tvSeries);
        }

        final message = notifier.watchlistMessage;

        if (message == TvSeriesDetailNotifier.watchlistAddSuccessMessage ||
            message == TvSeriesDetailNotifier.watchlistRemoveSuccessMessage) {
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

  Consumer<TvSeriesDetailNotifier> _buildRecommendationTvSeries() {
    return Consumer<TvSeriesDetailNotifier>(
      builder: (context, data, child) {
        if (data.recommendationState == RequestState.Loading) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (data.recommendationState == RequestState.Error) {
          return Text(data.message);
        } else if (data.recommendationState == RequestState.Loaded) {
          return Container(
            height: 200,
            margin: const EdgeInsets.only(top: 10),
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              separatorBuilder: (context, index) => const SizedBox(width: 15),
              itemBuilder: (context, index) {
                final tv = data.tvSeriesRecommendation[index];
                final posterPath =
                    'https://image.tmdb.org/t/p/w500${tv.posterPath}';

                return Padding(
                  padding: const EdgeInsets.all(0),
                  child: InkWell(
                    onTap: () {
                      Navigator.pushReplacementNamed(
                        context,
                        TvSeriesDetailPage.ROUTE_NAME,
                        arguments: tv.id,
                      );
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(
                        Radius.circular(4),
                      ),
                      child: CachedNetworkImage(
                        width: 120,
                        fit: BoxFit.cover,
                        imageUrl: posterPath,
                        placeholder: (context, url) => Shimmer.fromColors(
                          baseColor: Colors.grey[700]!,
                          highlightColor: Colors.grey[500]!,
                          enabled: true,
                          child: Container(
                            height: 130,
                            color: Colors.grey,
                          ),
                        ),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      ),
                    ),
                  ),
                );
              },
              itemCount: tvSeriesRecommendations.length,
            ),
          );
        } else {
          return Container();
        }
      },
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
}
