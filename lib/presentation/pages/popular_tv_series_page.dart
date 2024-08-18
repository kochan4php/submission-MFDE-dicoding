import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/presentation/provider/popular_tv_series_notifier.dart';
import 'package:ditonton/presentation/widgets/tv_series_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PopularTvSeriesPage extends StatefulWidget {
  static const ROUTE_NAME = '/popular-tv-series';

  @override
  State<PopularTvSeriesPage> createState() => _PopularTvSeriesPageState();
}

class _PopularTvSeriesPageState extends State<PopularTvSeriesPage> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      Provider.of<PopularTvSeriesNotifier>(context, listen: false)
          .fetchPopularTvSeries();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Popular Tv Series'),
        forceMaterialTransparency: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Consumer<PopularTvSeriesNotifier>(
          builder: (context, data, child) {
            final state = data.popularTvSeriesState;

            if (state == RequestState.Loading) {
              return Center(child: CircularProgressIndicator());
            } else if (state == RequestState.Loaded) {
              return ListView.builder(
                itemBuilder: (context, index) => TvSeriesCard(
                  data.popularTvSeries[index],
                ),
                itemCount: data.popularTvSeries.length,
              );
            } else {
              return Center(
                key: Key('error_message'),
                child: Text(data.message),
              );
            }
          },
        ),
      ),
    );
  }
}
