import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/usecases/search_movies.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final SearchMovies searchMovies;

  SearchBloc({required this.searchMovies}) : super(SearchEmpty()) {
    on<OnQueryChanged>(
      (event, emit) async {
        final String query = event.query;

        emit(SearchLoading());

        final result = await searchMovies.execute(query);

        result.fold(
          (failure) {
            emit(SearchError(failure.message));
          },
          (data) {
            emit(SearchHasData(data));
          },
        );
      },
      transformer: (events, mapper) {
        return events.debounceTime(Duration(milliseconds: 500)).flatMap(mapper);
      },
    );
  }
}
