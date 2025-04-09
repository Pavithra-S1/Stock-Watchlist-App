import '../../../domain/entities/watchlist_symbol.dart';

abstract class WatchlistRepository {
  Future<List<WatchlistSymbol>> getSymbolsByGroup(String group);
  Future<void> saveSymbolsToGroup(String group, List<WatchlistSymbol> symbols);
  Future<List<String>> getAllGroupNames();
  Future<void> deleteGroup(String group);
  Future<void> renameGroup(int index, String newName);
  Future<void> reorderGroups(int oldIndex, int newIndex);
}
