import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/presentation/provider/popular_movies_notifier.dart';
import 'package:ditonton/presentation/widgets/movie_card_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PopularMoviesPage extends StatefulWidget {
  static const ROUTE_NAME = '/popular-movie';

  @override
  _PopularMoviesPageState createState() => _PopularMoviesPageState();
}

class _PopularMoviesPageState extends State<PopularMoviesPage> {
  @override
  void initState() {
    super.initState();

    Future.microtask(
      () => Provider.of<PopularMoviesNotifier>(context, listen: false)
          .fetchPopularMovies(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Popular Movies'),
        forceMaterialTransparency: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Consumer<PopularMoviesNotifier>(
          builder: (context, data, child) {
            final state = data.state;

            if (state == RequestState.Loading) {
              return Center(child: CircularProgressIndicator());
            } else if (state == RequestState.Loaded) {
              return ListView.builder(
                itemBuilder: (context, index) => MovieCard(data.movies[index]),
                itemCount: data.movies.length,
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
