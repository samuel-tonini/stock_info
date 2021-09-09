import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:stock_info/data/protocols/protocols.dart';
import 'package:stock_info/data/usecases/usecases.dart';

import 'package:stock_info/domain/models/models.dart';

main() {
  late LoadStockPriceHistoryUsecase sut;
  late Ticker ticker;
  late PriceInterval priceInterval;
  late LoadStockPriceHistoryRepositorySpy loadStockPriceHistoryRepository;
  late List<HistoricalStockPrice> prices;

  setUp(() {
    priceInterval = PriceInterval.oneDay;
    ticker = Ticker('AAPL');
    loadStockPriceHistoryRepository = LoadStockPriceHistoryRepositorySpy();
    sut = LoadStockPriceHistoryUsecase(loadStockPriceHistoryRepository);
    prices = [
      HistoricalStockPrice(ticker: 'AAPL', at: DateTime.fromMillisecondsSinceEpoch(1587475800 * 1000), price: 272.37),
      HistoricalStockPrice(ticker: 'AAPL', at: DateTime.fromMillisecondsSinceEpoch(1587476700 * 1000), price: 273.19),
      HistoricalStockPrice(ticker: 'AAPL', at: DateTime.fromMillisecondsSinceEpoch(1587477600 * 1000), price: 272.31),
      HistoricalStockPrice(ticker: 'AAPL', at: DateTime.fromMillisecondsSinceEpoch(1587478500 * 1000), price: 270.65),
      HistoricalStockPrice(ticker: 'AAPL', at: DateTime.fromMillisecondsSinceEpoch(1587479400 * 1000), price: 269.25),
    ];
    when(loadStockPriceHistoryRepository.priceHistory(
      ticker: ticker,
      priceInterval: priceInterval,
    )).thenAnswer(
      (_) async => prices,
    );
  });

  test('Should call LoadStockPriceHistoryRepository.companyInfo with correct values', () async {
    await sut(
      ticker: ticker,
      priceInterval: priceInterval,
    );

    verify(loadStockPriceHistoryRepository.priceHistory(
      ticker: ticker,
      priceInterval: priceInterval,
    )).called(1);
  });

  test('Should return price historical data', () async {
    final result = await sut(
      ticker: ticker,
      priceInterval: priceInterval,
    );

    expect(result, prices);
    expect(result.length, prices.length);
  });

  test('Should throw if loadStockPriceHistoryRepository.companyInfo throws', () async {
    when(loadStockPriceHistoryRepository.priceHistory(
      ticker: ticker,
      priceInterval: priceInterval,
    )).thenThrow(Error());

    final future = sut(
      ticker: ticker,
      priceInterval: priceInterval,
    );

    expect(future, throwsA(isA<Error>()));
  });
}

class LoadStockPriceHistoryRepositorySpy extends Mock implements LoadStockPriceHistoryRepository {
  @override
  Future<List<HistoricalStockPrice>> priceHistory(
      {required Ticker ticker, required PriceInterval priceInterval}) async {
    return super.noSuchMethod(
      Invocation.method(#priceHistory, [], {#ticker: ticker, #priceInterval: priceInterval}),
      returnValue: <HistoricalStockPrice>[],
    );
  }
}
