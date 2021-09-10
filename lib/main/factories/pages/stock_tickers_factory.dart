import 'package:flutter/widgets.dart';

import '../../../presentation/ui/ui.dart';

import '../presenters/presenters.dart';

Widget makeStockTickersPage() {
  return StockTickersPage(makeGetxStockTickersPresenter());
}
