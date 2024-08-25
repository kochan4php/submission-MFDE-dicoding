import 'package:cached_network_image/cached_network_image.dart';
import 'package:ditonton/common/constants.dart';
import 'package:ditonton/domain/entities/genre.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:ditonton/domain/entities/tv_series_detail.dart';
import 'package:ditonton/presentation/bloc/tv_series/detail_tv_series/detail_tv_series_bloc.dart';
import 'package:ditonton/presentation/bloc/tv_series/watchlist_tv_series/watchlist_tv_series_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
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
      context.read<DetailTvSeriesBloc>().add(DetailTvSeriesGetEvent(widget.id));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<DetailTvSeriesBloc, DetailTvSeriesState>(
        builder: (context, state) {
          print(state);

          if (state is DetailTvSeriesLoading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is DetailTvSeriesHasData) {
            return SafeArea(
              child: DetailContent(
                state.detailTvSeries,
                state.recommendationsTvSeries,
                state.isWatchlistTvSeries,
              ),
            );
          } else if (state is DetailTvSeriesError) {
            return Center(child: Text(state.message));
          } else {
            return Center(child: Text('No Data'));
          }
        },
      ),
    );
  }
}

class DetailContent extends StatefulWidget {
  final TvSeriesDetail tvSeries;
  final List<TvSeries> tvSeriesRecommendations;
  bool isAddedWatchlist;

  DetailContent(
    this.tvSeries,
    this.tvSeriesRecommendations,
    this.isAddedWatchlist,
  );

  @override
  State<DetailContent> createState() => _DetailContentState();
}

class _DetailContentState extends State<DetailContent> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Stack(
      children: [
        CachedNetworkImage(
          imageUrl:
              'https://image.tmdb.org/t/p/w500${widget.tvSeries.posterPath}',
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
                            Text(widget.tvSeries.name, style: kHeading5),
                            _buildWatchlistButton(context),
                            Text(_showGenres(widget.tvSeries.genres)),
                            Row(
                              children: [
                                RatingBarIndicator(
                                  rating: widget.tvSeries.voteAverage / 2,
                                  itemCount: 5,
                                  itemBuilder: (context, index) => Icon(
                                    Icons.star,
                                    color: kMikadoYellow,
                                  ),
                                  itemSize: 24,
                                ),
                                Text('${widget.tvSeries.voteAverage}')
                              ],
                            ),
                            SizedBox(height: 16),
                            Text('Overview', style: kHeading6),
                            Text(widget.tvSeries.overview),
                            SizedBox(height: 16),
                            Text('Recommendations', style: kHeading6),
                            Recommendations(
                              recommendations: widget.tvSeriesRecommendations,
                            ),
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

  Widget _buildWatchlistButton(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: kMikadoYellow,
        foregroundColor: kRichBlack,
      ),
      onPressed: () async {
        String message;

        if (!widget.isAddedWatchlist) {
          context
              .read<WatchlistTvSeriesBloc>()
              .add(WatchlistTvSeriesAddEvent(widget.tvSeries));

          message = 'Success added to watchlist';
        } else {
          context
              .read<WatchlistTvSeriesBloc>()
              .add(WatchlistTvSeriesRemoveEvent(widget.tvSeries));

          message = 'Success remove from watchlist';
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message)),
        );

        setState(() {
          widget.isAddedWatchlist = !widget.isAddedWatchlist;
        });
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          widget.isAddedWatchlist ? Icon(Icons.check) : Icon(Icons.add),
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
}

class Recommendations extends StatelessWidget {
  final List<TvSeries> recommendations;

  const Recommendations({
    Key? key,
    required this.recommendations,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      margin: const EdgeInsets.only(top: 10),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        separatorBuilder: (context, index) => const SizedBox(width: 15),
        itemBuilder: (context, index) {
          final tv = recommendations[index];
          final posterPath = 'https://image.tmdb.org/t/p/w500${tv.posterPath}';

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
        itemCount: recommendations.length,
      ),
    );
  }
}
