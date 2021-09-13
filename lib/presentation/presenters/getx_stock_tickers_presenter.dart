import 'package:get/get.dart';

import '../../domain/models/models.dart';
import '../../domain/usecases/usecases.dart';

import '../protocols/protocols.dart';

class GetxStockTickersPresenter implements StockTickersPresenter {
  GetxStockTickersPresenter(this.loadStockTickers);

  List<Ticker> _allLoadedTickers = <Ticker>[];
  final _tickers = Rx<List<String>>(<String>[]);
  final LoadStockTickers loadStockTickers;
  String _filter = '';

  @override
  Stream<List<String>> get tickersStream => _tickers.stream;

  @override
  void goToCompanyInfo(String ticker) {
    Get.toNamed('/company_info/$ticker');
  }

  void _doFilter() {
    _tickers.value = _allLoadedTickers
        .where((ticker) => _filter == '' ? true : ticker.abreviation.toUpperCase().contains(_filter.toUpperCase()))
        .map((ticker) => ticker.abreviation)
        .toList();
  }

  @override
  Future<void> load() async {
    try {
      _tickers.value = [];
      final tickers = await loadStockTickers();
      _allLoadedTickers = tickers;
      _doFilter();
    } catch (_) {
      _tickers.addError(
        Error(),
        StackTrace.empty,
      );
    }
  }

  @override
  set filter(String newFilter) {
    if (_filter != newFilter) {
      _filter = newFilter;
      _doFilter();
    }
  }
}
