
import '../../../watchlist/domain/entities/watchlist_symbol.dart';

abstract class WatchlistState {}

class WatchlistInitial extends WatchlistState {}

class WatchlistLoaded extends WatchlistState {
  final List<WatchlistSymbol> symbols;
  final bool isEditMode;

  WatchlistLoaded({required this.symbols, this.isEditMode = false});
}