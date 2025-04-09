import 'package:shared_preferences/shared_preferences.dart';
import '../../../features/watchlist/data/datasources/watchlist_local_data_source.dart';
import '../../../features/watchlist/domain/entities/watchlist_symbol.dart';

class AppInitializer {
  static Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString('watchlist_data');

    if (raw == null) {
      final local = WatchlistLocalDataSource();

      await local.saveSymbolsToGroup('Watchlist 1', [
        WatchlistSymbol(name: 'RELIANCE', exchange: 'NSE', price: 2400.0, change: 12.5, percent: 0.52),
        WatchlistSymbol(name: 'TCS', exchange: 'NSE', price: 3300.0, change: 8.3, percent: 0.25),
        WatchlistSymbol(name: 'INFY', exchange: 'NSE', price: 1500.0, change: -6.2, percent: -0.41),
      ]);

      await local.saveSymbolsToGroup('NIFTY', [
        WatchlistSymbol(name: 'HDFC', exchange: 'NSE', price: 1620.0, change: 5.2, percent: 0.32),
        WatchlistSymbol(name: 'SBIN', exchange: 'NSE', price: 565.0, change: 3.1, percent: 0.55),
      ]);

      await local.saveSymbolsToGroup('BANKNIFTY', [
        WatchlistSymbol(name: 'ICICIBANK', exchange: 'NSE', price: 930.0, change: 4.8, percent: 0.52),
      ]);

      await local.saveSymbolsToGroup('Watchlist 2', [
        WatchlistSymbol(name: 'GROWW', exchange: 'NSE', price: 1020.9, change: 10.5, percent: 1.04),
      ]);
    }
  }
}
