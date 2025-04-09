import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../search/data/datasources/search_local_data_source.dart';
import 'search_event.dart';
import 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final SearchLocalDataSource dataSource;

  SearchBloc(this.dataSource) : super(SearchInitial()) {
    on<SearchQueryChanged>((event, emit) {
      final results = dataSource.searchSymbols(event.query);
      emit(SearchLoaded(results));
    });

    // Load default symbols initially
    add(SearchQueryChanged(''));
  }
}
