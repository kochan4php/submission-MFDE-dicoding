import 'package:ditonton/common/constants.dart';
import 'package:ditonton/presentation/pages/search_page.dart';
import 'package:ditonton/presentation/widgets/custom_drawer.dart';
import 'package:ditonton/presentation/widgets/sub_heading.dart';
import 'package:flutter/material.dart';

class AiringTvSeriesPage extends StatefulWidget {
  static const String ROUTE_NAME = '/airing-tv-series';

  @override
  State<AiringTvSeriesPage> createState() => _AiringTvSeriesPageState();
}

class _AiringTvSeriesPageState extends State<AiringTvSeriesPage> {
  @override
  void initState() {
    super.initState();
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
            onPressed: () {
              Navigator.pushNamed(context, SearchPage.ROUTE_NAME);
            },
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
                child: Text(
                  'Now Airing',
                  style: kHeading6,
                ),
              ),
              const SizedBox(height: 10),
              SubHeading(title: 'Popular', onTap: () {}),
              const SizedBox(height: 10),
              SubHeading(title: 'Top Rated', onTap: () {}),
            ],
          ),
        ),
      ),
    );
  }
}
