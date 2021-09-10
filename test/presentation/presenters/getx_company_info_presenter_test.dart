import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:stock_info/domain/models/models.dart';
import 'package:stock_info/domain/usecases/usecases.dart';

import 'package:stock_info/presentation/models/models.dart';
import 'package:stock_info/presentation/presenters/presenters.dart';

main() {
  late GetxCompanyInfoPresenter sut;
  late LoadCompanyInfoSpy loadCompanyInfo;
  late LoadStockPriceHistorySpy loadStockPriceHistory;
  late Ticker ticker;
  late CompanyInfo companyInfo;
  late List<HistoricalStockPrice> prices;
  late List<HistoricalStockPriceViewModel> pricesViewModel;

  setUp(() {
    loadCompanyInfo = LoadCompanyInfoSpy();
    loadStockPriceHistory = LoadStockPriceHistorySpy();
    ticker = Ticker('AAPL');
    prices = [
      HistoricalStockPrice(ticker: 'AAPL', at: DateTime.fromMillisecondsSinceEpoch(1587475800 * 1000), price: 272.37),
      HistoricalStockPrice(ticker: 'AAPL', at: DateTime.fromMillisecondsSinceEpoch(1587476700 * 1000), price: 273.19),
      HistoricalStockPrice(ticker: 'AAPL', at: DateTime.fromMillisecondsSinceEpoch(1587477600 * 1000), price: 272.31),
      HistoricalStockPrice(ticker: 'AAPL', at: DateTime.fromMillisecondsSinceEpoch(1587478500 * 1000), price: 270.65),
      HistoricalStockPrice(ticker: 'AAPL', at: DateTime.fromMillisecondsSinceEpoch(1587479400 * 1000), price: 269.25),
    ];
    pricesViewModel = prices.map((price) => HistoricalStockPriceViewModel(price)).toList();
    companyInfo = CompanyInfo(
      ticker: 'AAPL',
      address: 'One Apple Park Way',
      city: 'Cupertino',
      state: 'CA',
      zip: '95014',
      phone: '408-996-1010',
      webSite: 'http://www.apple.com',
      industry: 'Consumer Electronics',
      sector: 'Technology',
      country: 'United States',
      description:
          'Apple Inc. designs, manufactures, and markets smartphones, personal computers, tablets, wearables, and accessories worldwide.',
    );
    sut = GetxCompanyInfoPresenter(
      ticker: ticker,
      loadCompanyInfo: loadCompanyInfo,
      loadStockPriceHistory: loadStockPriceHistory,
    );
    when(loadCompanyInfo(ticker)).thenAnswer((_) async => companyInfo);
    when(loadStockPriceHistory(ticker: ticker, priceInterval: sut.priceInterval)).thenAnswer((_) async => prices);
  });

  test('Should call LoadCompanyInfo and LoadStockPriceHistory', () async {
    await sut.load();

    verify(loadCompanyInfo(ticker)).called(1);
    verify(loadStockPriceHistory(ticker: ticker, priceInterval: PriceInterval.oneHour)).called(1);
  });

  test('Should emit error if LoadCompanyInfo throws', () async {
    when(loadCompanyInfo(ticker)).thenThrow(Error());

    expectLater(sut.companyInfoStream, emitsInOrder([null, emitsError(isA<Error>())]));

    await sut.load();
  });

  test('Should emit error if LoadStockPriceHistory throws', () async {
    when(loadStockPriceHistory(ticker: ticker, priceInterval: PriceInterval.oneHour)).thenThrow(Error());

    expectLater(sut.historicalPriceStream, emitsInOrder([[], emitsError(isA<Error>())]));

    await sut.load();
  });

  test('Should emit null and after the result', () async {
    expectLater(sut.companyInfoStream, emitsInOrder([null, companyInfo]));

    await sut.load();
  });

  test('Should emit empty and after the result', () async {
    expectLater(sut.historicalPriceStream, emitsInOrder([[], pricesViewModel]));

    await sut.load();
  });

  test('Should use ticker abreviation as initial title', () async {
    expect(sut.title, ticker.abreviation);

    await sut.load();

    expect(sut.title, companyInfo.name);
  });

  test('Should start with one hour interval', () async {
    expect(sut.priceInterval, PriceInterval.oneHour);
  });

  test('Should change interval and reload historical data', () async {
    expect(sut.priceInterval, PriceInterval.oneHour);

    sut.priceInterval = PriceInterval.oneDay;

    expect(sut.priceInterval, PriceInterval.oneDay);
    verify(loadStockPriceHistory(ticker: ticker, priceInterval: PriceInterval.oneDay)).called(1);
  });

  test('Should not reload historical data if same interval was provided', () async {
    expect(sut.priceInterval, PriceInterval.oneHour);

    sut.priceInterval = PriceInterval.oneHour;

    verifyNever(loadStockPriceHistory(ticker: ticker, priceInterval: PriceInterval.oneHour));
  });
}

class LoadCompanyInfoSpy extends Mock implements LoadCompanyInfo {
  Future<CompanyInfo> call(Ticker ticker) async {
    return super.noSuchMethod(
      Invocation.method(#call, []),
      returnValue: CompanyInfo.empty(ticker.abreviation),
    );
  }
}

class LoadStockPriceHistorySpy extends Mock implements LoadStockPriceHistory {
  Future<List<HistoricalStockPrice>> call({
    required Ticker ticker,
    required PriceInterval priceInterval,
  }) async {
    return super.noSuchMethod(
      Invocation.method(#call, [], {#ticker: ticker, #priceInterval: priceInterval}),
      returnValue: <HistoricalStockPrice>[],
    );
  }
}
