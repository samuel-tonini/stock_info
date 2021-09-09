import '../../../domain/models/models.dart';

abstract class LoadStockPriceHistoryRepository {
  Future<List<HistoricalStockPrice>> priceHistory({required Ticker ticker, required PriceInterval priceInterval});
}
