import '../../domain/models/models.dart';
import '../../domain/usecases/usecases.dart';

import '../protocols/protocols.dart';

class LoadStockPriceHistoryUsecase implements LoadStockPriceHistory {
  LoadStockPriceHistoryUsecase(this.loadStockPriceHistoryRepository);

  final LoadStockPriceHistoryRepository loadStockPriceHistoryRepository;

  Future<List<HistoricalStockPrice>> call({
    required Ticker ticker,
    required PriceInterval priceInterval,
  }) async {
    final result = await loadStockPriceHistoryRepository.priceHistory(
      ticker: ticker,
      priceInterval: priceInterval,
    );
    result.sort((a, b) => a.at.compareTo(b.at));
    return result;
  }
}
