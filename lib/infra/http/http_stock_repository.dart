import '../../data/protocols/protocols.dart';
import '../../domain/models/models.dart';

import '../protocols/protocols.dart';

class HttpStockRepository implements LoadStockTickersRepository {
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
}
