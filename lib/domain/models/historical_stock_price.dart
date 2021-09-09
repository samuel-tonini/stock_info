import 'package:equatable/equatable.dart';

class HistoricalStockPrice extends Equatable {
  HistoricalStockPrice({
    required this.ticker,
    required this.at,
    required this.price,
  }) {
    if (ticker.isEmpty) {
      throw ArgumentError.value('', 'ticker', 'Ticker must to have a value');
    }
  }

  final String ticker;
  final DateTime at;
  final double price;

  @override
  List<Object?> get props => [ticker, at, price];
}
