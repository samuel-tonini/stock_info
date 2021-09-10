import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

import '../../domain/models/models.dart';
import '../../domain/usecases/usecases.dart';

import '../protocols/protocols.dart';
import '../models/models.dart';

class GetxCompanyInfoPresenter implements CompanyInfoPresenter {
  GetxCompanyInfoPresenter({
    required this.ticker,
    required this.loadCompanyInfo,
    required this.loadStockPriceHistory,
  }) : _title = ticker.abreviation;

  String _title;
  final _companyInfo = Rx<CompanyInfo?>(null);
  final _priceInterval = Rx<PriceInterval>(PriceInterval.oneHour)..value = PriceInterval.oneHour;
  final _historicalPrice = Rx<List<HistoricalStockPriceViewModel>>(<HistoricalStockPriceViewModel>[]);
  final Ticker ticker;
  final LoadCompanyInfo loadCompanyInfo;
  final LoadStockPriceHistory loadStockPriceHistory;

  @override
  String get title => _title;

  @override
  Stream<CompanyInfo?> get companyInfoStream => _companyInfo.stream;

  @override
  Stream<List<HistoricalStockPriceViewModel>> get historicalPriceStream => _historicalPrice.stream;

  @override
  Stream<PriceInterval> get priceIntervalStream => _priceInterval.stream;

  @override
  set priceInterval(PriceInterval newPriceInterval) {
    if (newPriceInterval != _priceInterval.value) {
      _priceInterval.value = newPriceInterval;
      _loadHistoricalStockPrice();
    }
  }

  Future<void> _loadHistoricalStockPrice() async {
    try {
      _historicalPrice.value = [];
      final historicalPrice = await loadStockPriceHistory(
        ticker: ticker,
        priceInterval: _priceInterval.value,
      );
      _historicalPrice.value = historicalPrice.map((price) => HistoricalStockPriceViewModel(price)).toList();
    } catch (error) {
      _historicalPrice.addError(
        error,
        StackTrace.empty,
      );
    }
  }

  @override
  Future<void> load() async {
    try {
      _companyInfo.value = null;
      _title = ticker.abreviation;
      final companyInfo = await loadCompanyInfo(ticker);
      _title = companyInfo.name;
      _companyInfo.value = companyInfo;
    } catch (error) {
      _companyInfo.addError(
        error,
        StackTrace.empty,
      );
    }
    _loadHistoricalStockPrice();
  }
}
