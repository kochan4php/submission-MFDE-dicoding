import 'package:ditonton/presentation/bloc/movies/search_movies/search_bloc.dart';
import 'package:ditonton/presentation/bloc/tv_series/tv_series_search/tv_series_search_bloc.dart';
import 'package:ditonton/presentation/widgets/movie_card_list.dart';
import 'package:ditonton/presentation/widgets/tv_series_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
              onChanged: (query) {
                isSearchMovie
                    ? context.read<SearchBloc>().add(OnQueryChanged(query))
                    : context
                        .read<TvSeriesSearchBloc>()
                        .add(OnTvSeriesQueryChanged(query));
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
        ? BlocBuilder<SearchBloc, SearchState>(
            builder: (context, state) {
              if (state is SearchLoading) {
                return Center(child: CircularProgressIndicator());
              } else if (state is SearchHasData) {
                final result = state.movies;

                return Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemBuilder: (context, index) => MovieCard(
                      result[index],
                    ),
                    itemCount: result.length,
                  ),
                );
              } else {
                return Expanded(child: Container());
              }
            },
          )
        : BlocBuilder<TvSeriesSearchBloc, TvSeriesSearchState>(
            builder: (context, state) {
              if (state is TvSeriesSearchLoading) {
                return Center(child: CircularProgressIndicator());
              } else if (state is TvSeriesSearchHasData) {
                final result = state.tvSeries;

                return Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemBuilder: (context, index) => TvSeriesCard(
                      result[index],
                    ),
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
