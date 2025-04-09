class WatchlistSymbol {
  final String name;
  final String exchange;
  final double price;
  final double change;
  final double percent;

  const WatchlistSymbol({
    required this.name,
    required this.exchange,
    required this.price,
    required this.change,
    required this.percent,
  });

  factory WatchlistSymbol.fromJson(Map<String, dynamic> json) {
    return WatchlistSymbol(
      name: json['name'],
      exchange: json['exchange'],
      price: (json['price'] as num).toDouble(),
      change: (json['change'] as num).toDouble(),
      percent: (json['percent'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'exchange': exchange,
      'price': price,
      'change': change,
      'percent': percent,
    };
  }
}
