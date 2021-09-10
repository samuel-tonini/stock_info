import '../../../presentation/presenters/presenters.dart';
import '../../../presentation/protocols/protocols.dart';

import '../usecase/usecase.dart';

StockTickersPresenter makeGetxStockTickersPresenter() {
  return GetxStockTickersPresenter(makeHttpLoadStockTickersUsecase());
}
