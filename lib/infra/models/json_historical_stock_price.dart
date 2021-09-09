import '../../domain/models/models.dart';

class JsonHistoricalStockPrice {
  static HistoricalStockPrice fromJson({
    required String ticker,
    required int at,
    required Map json,
  }) {
    return HistoricalStockPrice(
      ticker: ticker,
      at: DateTime.fromMillisecondsSinceEpoch(at * 1000),
      price: double.tryParse(json['close'].toString()) ?? 0,
    );
  }
}
