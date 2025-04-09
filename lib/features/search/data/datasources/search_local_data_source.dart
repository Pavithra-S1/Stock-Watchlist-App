import '../../../search/domain/entities/search_symbol.dart';

class SearchLocalDataSource {
  final List<SearchSymbol> _mockSymbols = [
    SearchSymbol(name: 'RELIANCE', exchange: 'NSE'),
    SearchSymbol(name: 'TCS', exchange: 'NSE'),
    SearchSymbol(name: 'ICICIBANK', exchange: 'NSE'),
    SearchSymbol(name: 'HDFCBANK', exchange: 'NSE'),
    SearchSymbol(name: 'INFY', exchange: 'NSE'),
    SearchSymbol(name: 'ACC', exchange: 'NSE'),
  ];

  List<SearchSymbol> getAllSymbols() {
    return _mockSymbols;
  }

  List<SearchSymbol> searchSymbols(String query) {
    if (query.trim().isEmpty) return _mockSymbols;
    return _mockSymbols
        .where((s) => s.name.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }
}
