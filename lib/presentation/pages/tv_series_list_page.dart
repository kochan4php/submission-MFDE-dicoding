import 'package:cached_network_image/cached_network_image.dart';
import 'package:ditonton/common/constants.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:ditonton/presentation/bloc/tv_series/popular_tv_series/popular_tv_series_bloc.dart';
import 'package:ditonton/presentation/bloc/tv_series/top_rated_tv_series/top_rated_tv_series_bloc.dart';
import 'package:ditonton/presentation/bloc/tv_series/tv_series_now_airing/tv_series_now_airing_bloc.dart';
import 'package:ditonton/presentation/pages/airing_tv_series_page.dart';
import 'package:ditonton/presentation/pages/popular_tv_series_page.dart';
import 'package:ditonton/presentation/pages/search_page.dart';
import 'package:ditonton/presentation/pages/top_rated_tv_series_page.dart';
import 'package:ditonton/presentation/pages/tv_series_detail_page.dart';
import 'package:ditonton/presentation/widgets/custom_drawer.dart';
import 'package:ditonton/presentation/widgets/sub_heading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';

class TvSeriesListPage extends StatefulWidget {
  static const String ROUTE_NAME = '/list-tv-series';

  @override
  State<TvSeriesListPage> createState() => _TvSeriesListPageState();
}

class _TvSeriesListPageState extends State<TvSeriesListPage> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      context.read<TvSeriesNowAiringBloc>().add(TvSeriesNowAiringGetEvent());
      context.read<PopularTvSeriesBloc>().add(PopularTvSeriesGetEvent());
      context.read<TopRatedTvSeriesBloc>().add(TopRatedTvSeriesGetEvent());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomDrawer(),
      appBar: AppBar(
        title: Text('Ditonton'),
        forceMaterialTransparency: true,
        actions: [
          IconButton(
            onPressed: () => Navigator.pushNamed(
              context,
              SearchPage.ROUTE_NAME,
              arguments: false,
            ),
            icon: Icon(Icons.search),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SubHeading(
                title: 'Now Airing',
                onTap: () => Navigator.pushNamed(
                  context,
                  AiringTvSeriesPage.ROUTE_NAME,
                ),
              ),
              BlocBuilder<TvSeriesNowAiringBloc, TvSeriesNowAiringState>(
                builder: (context, state) {
                  if (state is TvSeriesNowAiringLoading) {
                    return Center(child: CircularProgressIndicator());
                  } else if (state is TvSeriesNowAiringHasData) {
                    return TvSeriesList(tvSeries: state.tvSeries);
                  } else {
                    return Container(
                      padding: const EdgeInsets.all(10),
                      child: Center(
                        child: Text('Failed'),
                      ),
                    );
                  }
                },
              ),
              SubHeading(
                title: 'Popular',
                onTap: () => Navigator.pushNamed(
                  context,
                  PopularTvSeriesPage.ROUTE_NAME,
                ),
              ),
              BlocBuilder<PopularTvSeriesBloc, PopularTvSeriesState>(
                builder: (context, state) {
                  if (state is PopularTvSeriesLoading) {
                    return Center(child: CircularProgressIndicator());
                  } else if (state is PopularTvSeriesHasData) {
                    return TvSeriesList(tvSeries: state.tvSeries);
                  } else {
                    return Container(
                      padding: const EdgeInsets.all(10),
                      child: Center(
                        child: Text('Failed'),
                      ),
                    );
                  }
                },
              ),
              const SizedBox(height: 10),
              SubHeading(
                title: 'Top Rated',
                onTap: () => Navigator.pushNamed(
                  context,
                  TopRatedTvSeriesPage.ROUTE_NAME,
                ),
              ),
              BlocBuilder<TopRatedTvSeriesBloc, TopRatedTvSeriesState>(
                builder: (context, state) {
                  if (state is TopRatedTvSeriesLoading) {
                    return Center(child: CircularProgressIndicator());
                  } else if (state is TopRatedTvSeriesHasData) {
                    return TvSeriesList(tvSeries: state.tvSeries);
                  } else {
                    return Container(
                      padding: const EdgeInsets.all(10),
                      child: Center(
                        child: Text('Failed'),
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TvSeriesList extends StatelessWidget {
  final List<TvSeries> tvSeries;

  const TvSeriesList({Key? key, required this.tvSeries}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: tvSeries.length,
        itemBuilder: (context, index) {
          final tv = tvSeries[index];

          return Container(
            padding: const EdgeInsets.all(8),
            child: GestureDetector(
              onTap: () => Navigator.pushNamed(
                context,
                TvSeriesDetailPage.ROUTE_NAME,
                arguments: tv.id,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(16)),
                child: CachedNetworkImage(
                  imageUrl: '$BASE_IMAGE_URL${tv.posterPath}',
                  width: 130,
                  fit: BoxFit.cover,
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
      ),
    );
  }
}
