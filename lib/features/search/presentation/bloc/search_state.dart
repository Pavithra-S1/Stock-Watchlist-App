import '../../../search/domain/entities/search_symbol.dart';

abstract class SearchState {}

class SearchInitial extends SearchState {}

class SearchLoaded extends SearchState {
  final List<SearchSymbol> results;

  SearchLoaded(this.results);
}
