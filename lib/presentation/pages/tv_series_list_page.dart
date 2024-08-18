import 'package:cached_network_image/cached_network_image.dart';
import 'package:ditonton/common/constants.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:ditonton/presentation/pages/popular_tv_series_page.dart';
import 'package:ditonton/presentation/pages/search_page.dart';
import 'package:ditonton/presentation/pages/top_rated_tv_series_page.dart';
import 'package:ditonton/presentation/pages/tv_series_detail_page.dart';
import 'package:ditonton/presentation/provider/tv_series_list_notifier.dart';
import 'package:ditonton/presentation/widgets/custom_drawer.dart';
import 'package:ditonton/presentation/widgets/sub_heading.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class TvSeriesListPage extends StatefulWidget {
  static const String ROUTE_NAME = '/airing-tv-series';

  @override
  State<TvSeriesListPage> createState() => _TvSeriesListPageState();
}

class _TvSeriesListPageState extends State<TvSeriesListPage> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      Provider.of<TvSeriesListNotifier>(context, listen: false)
        ..fetchNowAiringTvSeries()
        ..fetchPopularTvSeries()
        ..fetchTopRatedTvSeries();
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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text('Now Airing', style: kHeading6),
              ),
              const SizedBox(height: 10),
              Consumer<TvSeriesListNotifier>(
                builder: (context, data, child) {
                  final state = data.nowAiringState;

                  if (state == RequestState.Loading) {
                    return Center(child: CircularProgressIndicator());
                  } else if (state == RequestState.Loaded) {
                    return TvSeriesList(tvSeries: data.nowAiringTvSeries);
                  } else {
                    return Text('Failed');
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
              Consumer<TvSeriesListNotifier>(
                builder: (context, data, child) {
                  final state = data.popularTvSeriesState;

                  if (state == RequestState.Loading) {
                    return Center(child: CircularProgressIndicator());
                  } else if (state == RequestState.Loaded) {
                    return TvSeriesList(tvSeries: data.popularTvSeries);
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
                  TopRatedTvSeriesPage.ROUTE_NAME,
                ),
              ),
              Consumer<TvSeriesListNotifier>(
                builder: (context, data, child) {
                  final state = data.topRatedTvSeriesState;

                  if (state == RequestState.Loading) {
                    return Center(child: CircularProgressIndicator());
                  } else if (state == RequestState.Loaded) {
                    return TvSeriesList(tvSeries: data.topRatedTvSeries);
                  } else {
                    return Text('Failed');
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
