import '../../../domain/models/models.dart';

import '../../models/models.dart';

abstract class CompanyInfoPresenter {
  String get title;
  Stream<CompanyInfo?> get companyInfoStream;
  Stream<List<HistoricalStockPriceViewModel>> get historicalPriceStream;
  Stream<PriceInterval> get priceIntervalStream;
  set priceInterval(PriceInterval newPriceInterval);
  Future<void> load();
}
