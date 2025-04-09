// import 'package:equatable/equatable.dart';
import '../../domain/entities/watchlist_symbol.dart';

abstract class WatchlistEvent {}

class LoadWatchlist extends WatchlistEvent {
  final String group;
  LoadWatchlist(this.group);
}

class AddSymbolToWatchlist extends WatchlistEvent {
  final String group;
  final WatchlistSymbol symbol;
  AddSymbolToWatchlist({required this.group, required this.symbol});
}

class ToggleEditMode extends WatchlistEvent {}

class ReorderSymbol extends WatchlistEvent {
  final int oldIndex;
  final int newIndex;
  ReorderSymbol({required this.oldIndex, required this.newIndex});
}

class RemoveSymbol extends WatchlistEvent {
  final int index;
  RemoveSymbol(this.index);
}