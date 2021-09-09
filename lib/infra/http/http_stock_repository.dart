import '../../data/protocols/protocols.dart';
import '../../domain/models/models.dart';

import '../models/models.dart';
import '../protocols/protocols.dart';

class HttpStockRepository implements LoadStockTickersRepository, LoadCompanyInfoRepository {
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
  Future<CompanyInfo> companyInfo(String ticker) async {
    final rawJson = await httpClient.request('/qu/quote/$ticker/asset-profile');
    if (rawJson == null || rawJson == '') return CompanyInfo.empty(ticker);
    final rawMap = Map.from(rawJson);
    if (!rawMap.containsKey('assetProfile') || rawMap['assetProfile'] == null) return CompanyInfo.empty(ticker);
    Map rawCompanyInfo;
    try {
      rawCompanyInfo = Map.from(rawMap['assetProfile']);
    } catch (_) {
      return CompanyInfo.empty(ticker);
    }
    return JsonCompanyInfo.fromJson(
      ticker: ticker,
      json: rawCompanyInfo,
    );
  }
}
