import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/entities/watchlist_symbol.dart';

class WatchlistLocalDataSource {
  static const String _storageKey = 'watchlist_data';

  Future<Map<String, List<WatchlistSymbol>>> _loadAll() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_storageKey);

    if (raw == null) return {};

    final decoded = json.decode(raw) as Map<String, dynamic>;
    return decoded.map((group, symbolsJson) {
      final list = (symbolsJson as List)
          .map((item) => WatchlistSymbol.fromJson(item))
          .toList();
      return MapEntry(group, list);
    });
  }

  Future<void> _saveAll(Map<String, List<WatchlistSymbol>> allData) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonData = allData.map((key, value) {
      return MapEntry(key, value.map((e) => e.toJson()).toList());
    });
    await prefs.setString(_storageKey, json.encode(jsonData));
  }

  Future<List<WatchlistSymbol>> getSymbolsByGroup(String group) async {
    final data = await _loadAll();
    return data[group] ?? [];
  }

  Future<void> saveSymbolsToGroup(String group, List<WatchlistSymbol> symbols) async {
    final data = await _loadAll();
    data[group] = symbols;
    await _saveAll(data);
  }

  Future<List<String>> getAllGroupNames() async {
    final data = await _loadAll();
    return data.keys.toList();
  }

  Future<void> deleteGroup(String group) async {
    final data = await _loadAll();
    data.remove(group);
    await _saveAll(data);
  }

  Future<void> renameGroup(String oldName, String newName) async {
    final data = await _loadAll();
    if (data.containsKey(oldName)) {
      data[newName] = data[oldName]!;
      data.remove(oldName);
      await _saveAll(data);
    }
  }

  Future<void> reorderGroups(List<String> newOrder) async {
    final oldData = await _loadAll();
    final newData = <String, List<WatchlistSymbol>>{};
    for (var group in newOrder) {
      newData[group] = oldData[group] ?? [];
    }
    await _saveAll(newData);
  }
}
