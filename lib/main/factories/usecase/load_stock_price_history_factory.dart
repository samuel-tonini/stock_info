import '../../../data/usecases/usecases.dart';

import '../../../domain/usecases/usecases.dart';

import '../infra/infra.dart';

LoadStockPriceHistory makeHttpLoadStockPriceHistoryUsecase() {
  return LoadStockPriceHistoryUsecase(makeHttpLoadStockPriceHistoryRepository());
}
