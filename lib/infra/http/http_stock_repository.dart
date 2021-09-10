import '../../data/protocols/protocols.dart';
import '../../domain/models/models.dart';

import '../models/models.dart';
import '../protocols/protocols.dart';

class HttpStockRepository
    implements LoadStockTickersRepository, LoadCompanyInfoRepository, LoadStockPriceHistoryRepository {
  final HttpClient httpClient;

  HttpStockRepository(this.httpClient);

  @override
  Future<List<Ticker>> loadTickers() async {
    final rawJson = await httpClient.request('/tr/trending');
    if (rawJson == null || rawJson == '') return [];
    final rawList = List.from(rawJson);
    final rawMap = Map.from(rawList[0]);
    final tickersStringList = List.from(rawMap['quotes'] ?? []);
    return tickersStringList.map((tickerString) => Ticker(tickerString)).toList();
  }

  @override
  Future<CompanyInfo> companyInfo(Ticker ticker) async {
    final rawJson = await httpClient.request('/qu/quote/${ticker.abreviation}/asset-profile');
    if (rawJson == null || rawJson == '') return CompanyInfo.empty(ticker.abreviation);
    final rawMap = Map.from(rawJson);
    if (!rawMap.containsKey('assetProfile') || rawMap['assetProfile'] == null) {
      return CompanyInfo.empty(ticker.abreviation);
    }
    Map rawCompanyInfo;
    try {
      rawCompanyInfo = Map.from(rawMap['assetProfile']);
    } catch (_) {
      return CompanyInfo.empty(ticker.abreviation);
    }
    return JsonCompanyInfo.fromJson(
      ticker: ticker.abreviation,
      json: rawCompanyInfo,
    );
  }

  @override
  Future<List<HistoricalStockPrice>> priceHistory({
    required Ticker ticker,
    required PriceInterval priceInterval,
  }) async {
    final rawJson = await httpClient.request(
      '/hi/history/${ticker.abreviation}/${priceInterval.description}',
    );
    final result = <HistoricalStockPrice>[];
    if (rawJson == null || rawJson == '') {
      return result;
    }
    final rawMap = Map.from(rawJson);
    if (!rawMap.containsKey('items') || rawMap['items'] == null) {
      return result;
    }
    Map rawHistoricalData;
    try {
      rawHistoricalData = Map.from(rawMap['items']);
    } catch (_) {
      return result;
    }
    return rawHistoricalData.keys.map(
      (key) {
        return JsonHistoricalStockPrice.fromJson(
          ticker: ticker.abreviation,
          at: int.tryParse(key.toString()) ?? 0,
          json: rawHistoricalData[key],
        );
      },
    ).toList();
  }
}
