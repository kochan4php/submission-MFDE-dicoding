import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/presentation/provider/movie_search_notifier.dart';
import 'package:ditonton/presentation/provider/tv_series_search_notifier.dart';
import 'package:ditonton/presentation/widgets/movie_card_list.dart';
import 'package:ditonton/presentation/widgets/tv_series_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchPage extends StatelessWidget {
  static const ROUTE_NAME = '/search';

  final bool isSearchMovie;

  const SearchPage({Key? key, required this.isSearchMovie}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search ${isSearchMovie ? 'Movie' : 'Tv Series'}'),
        forceMaterialTransparency: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              onSubmitted: (query) {
                isSearchMovie
                    ? Provider.of<MovieSearchNotifier>(
                        context,
                        listen: false,
                      ).fetchMovieSearch(query)
                    : Provider.of<TvSeriesSearchNotifier>(
                        context,
                        listen: false,
                      ).fetchTvSeriesSearch(query);
              },
              decoration: InputDecoration(
                hintText: 'Search title',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              textInputAction: TextInputAction.search,
            ),
            SizedBox(height: 16),
            _searchResult(),
          ],
        ),
      ),
    );
  }

  Widget _searchResult() {
    return isSearchMovie
        ? Consumer<MovieSearchNotifier>(
            builder: (context, data, child) {
              if (data.state == RequestState.Loading) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else if (data.state == RequestState.Loaded) {
                final result = data.searchResult;
                return Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemBuilder: (context, index) {
                      final movie = data.searchResult[index];
                      return MovieCard(movie);
                    },
                    itemCount: result.length,
                  ),
                );
              } else {
                return Expanded(child: Container());
              }
            },
          )
        : Consumer<TvSeriesSearchNotifier>(
            builder: (context, data, child) {
              if (data.searchTvSeriesState == RequestState.Loading) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else if (data.searchTvSeriesState == RequestState.Loaded) {
                final result = data.searchResult;
                return Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemBuilder: (context, index) {
                      final tvSeries = data.searchResult[index];
                      return TvSeriesCard(tvSeries);
                    },
                    itemCount: result.length,
                  ),
                );
              } else {
                return Expanded(child: Container());
              }
            },
          );
  }
}
