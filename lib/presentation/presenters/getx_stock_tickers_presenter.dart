import 'package:get/get.dart';

import '../../domain/usecases/usecases.dart';

import '../protocols/protocols.dart';

class GetxStockTickersPresenter implements StockTickersPresenter {
  GetxStockTickersPresenter(this.loadStockTickers);

  final _tickers = Rx<List<String>>(<String>[]);
  final LoadStockTickers loadStockTickers;

  @override
  Stream<List<String>> get tickersStream => _tickers.stream;

  @override
  void goToCompanyInfo(String ticker) {
    Get.toNamed('/company_info/$ticker');
  }

  @override
  Future<void> load() async {
    try {
      _tickers.value = [];
      final tickers = await loadStockTickers();
      _tickers.value = tickers.map((ticker) => ticker.abreviation).toList();
    } catch (_) {
      _tickers.addError(
        Error(),
        StackTrace.empty,
      );
    }
  }
}
