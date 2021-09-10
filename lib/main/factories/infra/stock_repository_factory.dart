import '../../../data/protocols/protocols.dart';

import '../../../infra/http/http.dart';

import 'infra.dart';

HttpStockRepository _makeHttpStockRepository() => HttpStockRepository(makeHttpClient());

LoadStockTickersRepository makeHttpLoadStockTickersRepository() => _makeHttpStockRepository();

LoadCompanyInfoRepository makeHttpLoadCompanyInfoRepository() => _makeHttpStockRepository();

LoadStockPriceHistoryRepository makeHttpLoadStockPriceHistoryRepository() => _makeHttpStockRepository();
