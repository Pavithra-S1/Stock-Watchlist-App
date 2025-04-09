import '../../domain/entities/watchlist_symbol.dart';
import '../datasources/repositories/watchlist_repository.dart';
import '../datasources/watchlist_local_data_source.dart';

class WatchlistRepositoryImpl implements WatchlistRepository {
  final WatchlistLocalDataSource localDataSource;

  WatchlistRepositoryImpl(this.localDataSource);

  @override
  Future<List<WatchlistSymbol>> getSymbolsByGroup(String group) {
    return localDataSource.getSymbolsByGroup(group);
  }

  @override
  Future<void> saveSymbolsToGroup(String group, List<WatchlistSymbol> symbols) {
    return localDataSource.saveSymbolsToGroup(group, symbols);
  }

  @override
  Future<List<String>> getAllGroupNames() {
    return localDataSource.getAllGroupNames();
  }

  @override
  Future<void> deleteGroup(String group) {
    return localDataSource.deleteGroup(group);
  }

  @override
  Future<void> renameGroup(int index, String newName) async {
    final names = await getAllGroupNames();
    if (index >= 0 && index < names.length) {
      await localDataSource.renameGroup(names[index], newName);
    }
  }

  @override
  Future<void> reorderGroups(int oldIndex, int newIndex) async {
    final names = await getAllGroupNames();
    final moved = names.removeAt(oldIndex);
    names.insert(newIndex > oldIndex ? newIndex - 1 : newIndex, moved);
    await localDataSource.reorderGroups(names);
  }
}
