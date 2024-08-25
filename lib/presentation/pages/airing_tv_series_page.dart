import 'package:ditonton/presentation/bloc/tv_series/tv_series_now_airing/tv_series_now_airing_bloc.dart';
import 'package:ditonton/presentation/widgets/tv_series_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AiringTvSeriesPage extends StatefulWidget {
  static const ROUTE_NAME = '/airing-tv-series';

  @override
  State<AiringTvSeriesPage> createState() => _AiringTvSeriesPageState();
}

class _AiringTvSeriesPageState extends State<AiringTvSeriesPage> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      context.read<TvSeriesNowAiringBloc>().add(TvSeriesNowAiringGetEvent());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Airing Tv Series'),
        forceMaterialTransparency: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<TvSeriesNowAiringBloc, TvSeriesNowAiringState>(
          builder: (context, state) {
            if (state is TvSeriesNowAiringLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is TvSeriesNowAiringHasData) {
              return ListView.builder(
                itemBuilder: (context, index) => TvSeriesCard(
                  state.tvSeries[index],
                ),
                itemCount: state.tvSeries.length,
              );
            } else if (state is TvSeriesNowAiringError) {
              return Center(
                key: Key('error_message'),
                child: Text(state.message),
              );
            } else {
              return Center(
                key: Key('error_message'),
                child: Text('No Data'),
              );
            }
          },
        ),
      ),
    );
  }
}
