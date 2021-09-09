import '../models/models.dart';

abstract class LoadStockPriceHistory {
  Future<List<HistoricalStockPrice>> call({required Ticker ticker, required PriceInterval priceInterval});
}
