import '../../../data/usecases/usecases.dart';

import '../../../domain/usecases/usecases.dart';

import '../infra/infra.dart';

LoadStockTickers makeHttpLoadStockTickersUsecase() {
  return LoadStockTickersUsecase(makeHttpLoadStockTickersRepository());
}
