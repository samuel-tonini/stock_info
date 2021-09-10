import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:stock_info/domain/models/models.dart';

import 'package:stock_info/domain/models/ticker.dart';

import 'package:stock_info/infra/http/http.dart';
import 'package:stock_info/infra/protocols/protocols.dart';

main() {
  late HttpStockRepository sut;
  late HttpClientSpy httpClient;
  late String url;
  late dynamic sutResult;

  group('LoadStockTickersRepository', () {
    setUp(() {
      httpClient = HttpClientSpy();
      sut = HttpStockRepository(httpClient);
      url = '/tr/trending';
      sutResult = jsonDecode(
        '[{"count":9,"quotes":["LULU","GME","ATER","SOL1-USD","SE","ALGO-USD","HEX-USD","NQ=F","XLM-USD"],"jobTimestamp":1631156987440,"startInterval":202109090200}]',
      );
      when(httpClient.request(url)).thenAnswer((_) async => sutResult);
    });

    test('Should call HttpClient with correct values', () async {
      await sut.loadTickers();
      verify(httpClient.request(url)).called(1);
    });

    test('Should return HttpClient.request result converted to Tickers', () async {
      final result = await sut.loadTickers();
      expect(
        result,
        containsAll([
          Ticker('LULU'),
          Ticker('GME'),
          Ticker('ATER'),
          Ticker('SOL1-USD'),
          Ticker('SE'),
          Ticker('ALGO-USD'),
          Ticker('HEX-USD'),
          Ticker('NQ=F'),
          Ticker('XLM-USD'),
        ]),
      );
      expect(result.length, 9);
    });

    test('Should return empty list if HttpClient.request returns empty', () async {
      when(httpClient.request(url)).thenAnswer((_) async => '');
      final result = await sut.loadTickers();
      expect(result.length, 0);
    });

    test('Should return empty list if HttpClient.request returns null', () async {
      when(httpClient.request(url)).thenAnswer((_) async => null);
      final result = await sut.loadTickers();
      expect(result.length, 0);
    });

    test('Should return empty list if HttpClient.request returns empty quotes list', () async {
      sutResult = jsonDecode('[{"count":0,"quotes":[],"jobTimestamp":1631156987440,"startInterval":202109090200}]');
      when(httpClient.request(url)).thenAnswer((_) async => sutResult);
      final result = await sut.loadTickers();
      expect(result.length, 0);
    });

    test('Should return empty list if HttpClient.request returns without quotes field', () async {
      sutResult = jsonDecode('[{"count":0,"jobTimestamp":1631156987440,"startInterval":202109090200}]');
      when(httpClient.request(url)).thenAnswer((_) async => sutResult);
      final result = await sut.loadTickers();
      expect(result.length, 0);
    });

    test('Should throw if HttpClient.request throws', () async {
      when(httpClient.request(url)).thenThrow(Error());
      final future = sut.loadTickers();
      expect(future, throwsA(isA<Error>()));
    });
  });

  group('LoadCompanyInfoRepository', () {
    late Ticker ticker;
    late String address;
    late String city;
    late String state;
    late String zip;
    late String phone;
    late String webSite;
    late String industry;
    late String sector;
    late String country;
    late String description;
    late CompanyInfo companyInfo;

    setUp(() {
      httpClient = HttpClientSpy();
      sut = HttpStockRepository(httpClient);
      ticker = Ticker('AAPL');
      address = 'One Apple Park Way';
      city = 'Cupertino';
      state = 'CA';
      zip = '95014';
      phone = '408-996-1010';
      webSite = 'http://www.apple.com';
      industry = 'Consumer Electronics';
      sector = 'Technology';
      country = 'United States';
      description =
          'Apple Inc. designs, manufactures, and markets smartphones, personal computers, tablets, wearables, and accessories worldwide.';
      url = '/qu/quote/${ticker.abreviation}/asset-profile';
      sutResult = jsonDecode(
        '{"assetProfile":{"address1":"$address","city":"$city","state":"$state","zip":"$zip","country":"$country","phone":"$phone","website":"$webSite","industry":"$industry","sector":"$sector","longBusinessSummary":"$description","fullTimeEmployees":147000,"companyOfficers":[{"maxAge":1,"name":"Mr. Timothy D. Cook","age":59,"title":"CEO & Director","yearBorn":1961,"fiscalYear":2020,"totalPay":{"raw":14769259,"fmt":"14.77M","longFmt":"14,769,259"},"exercisedValue":{"raw":0,"fmt":null,"longFmt":"0"},"unexercisedValue":{"raw":0,"fmt":null,"longFmt":"0"}},{"maxAge":1,"name":"Mr. Luca  Maestri","age":56,"title":"CFO & Sr. VP","yearBorn":1964,"fiscalYear":2020,"totalPay":{"raw":4595583,"fmt":"4.6M","longFmt":"4,595,583"},"exercisedValue":{"raw":0,"fmt":null,"longFmt":"0"},"unexercisedValue":{"raw":0,"fmt":null,"longFmt":"0"}},{"maxAge":1,"name":"Mr. Jeffrey E. Williams","age":56,"title":"Chief Operating Officer","yearBorn":1964,"fiscalYear":2020,"totalPay":{"raw":4594137,"fmt":"4.59M","longFmt":"4,594,137"},"exercisedValue":{"raw":0,"fmt":null,"longFmt":"0"},"unexercisedValue":{"raw":0,"fmt":null,"longFmt":"0"}},{"maxAge":1,"name":"Ms. Katherine L. Adams","age":56,"title":"Sr. VP, Gen. Counsel & Sec.","yearBorn":1964,"fiscalYear":2020,"totalPay":{"raw":4591310,"fmt":"4.59M","longFmt":"4,591,310"},"exercisedValue":{"raw":0,"fmt":null,"longFmt":"0"},"unexercisedValue":{"raw":0,"fmt":null,"longFmt":"0"}},{"maxAge":1,"name":"Ms. Deirdre  O\'Brien","age":53,"title":"Sr. VP of People & Retail","yearBorn":1967,"fiscalYear":2020,"totalPay":{"raw":4614684,"fmt":"4.61M","longFmt":"4,614,684"},"exercisedValue":{"raw":0,"fmt":null,"longFmt":"0"},"unexercisedValue":{"raw":0,"fmt":null,"longFmt":"0"}},{"maxAge":1,"name":"Mr. Chris  Kondo","title":"Sr. Director of Corp. Accounting","exercisedValue":{"raw":0,"fmt":null,"longFmt":"0"},"unexercisedValue":{"raw":0,"fmt":null,"longFmt":"0"}},{"maxAge":1,"name":"Mr. James  Wilson","title":"Chief Technology Officer","exercisedValue":{"raw":0,"fmt":null,"longFmt":"0"},"unexercisedValue":{"raw":0,"fmt":null,"longFmt":"0"}},{"maxAge":1,"name":"Ms. Mary  Demby","title":"Chief Information Officer","exercisedValue":{"raw":0,"fmt":null,"longFmt":"0"},"unexercisedValue":{"raw":0,"fmt":null,"longFmt":"0"}},{"maxAge":1,"name":"Ms. Nancy  Paxton","title":"Sr. Director of Investor Relations & Treasury","exercisedValue":{"raw":0,"fmt":null,"longFmt":"0"},"unexercisedValue":{"raw":0,"fmt":null,"longFmt":"0"}},{"maxAge":1,"name":"Mr. Greg  Joswiak","title":"Sr. VP of Worldwide Marketing","exercisedValue":{"raw":0,"fmt":null,"longFmt":"0"},"unexercisedValue":{"raw":0,"fmt":null,"longFmt":"0"}}],"auditRisk":3,"boardRisk":1,"compensationRisk":2,"shareHolderRightsRisk":1,"overallRisk":1,"governanceEpochDate":1625097600,"compensationAsOfEpochDate":1609372800,"maxAge":86400}}',
      );
      companyInfo = CompanyInfo(
        ticker: ticker.abreviation,
        address: address,
        city: city,
        state: state,
        zip: zip,
        phone: phone,
        webSite: webSite,
        industry: industry,
        sector: sector,
        country: country,
        description: description,
      );
      when(httpClient.request(url)).thenAnswer((_) async => sutResult);
    });

    test('Should call HttpClient with correct values', () async {
      await sut.companyInfo(ticker);

      verify(httpClient.request(url)).called(1);
    });

    test('Should return HttpClient.request result converted to company info', () async {
      final result = await sut.companyInfo(ticker);

      expect(result, companyInfo);
    });

    test('Should return empty company info if HttpClient.request returns empty', () async {
      when(httpClient.request(url)).thenAnswer((_) async => '');

      final result = await sut.companyInfo(ticker);

      expect(result, CompanyInfo.empty(ticker.abreviation));
    });

    test('Should return empty company info if HttpClient.request returns null', () async {
      when(httpClient.request(url)).thenAnswer((_) async => null);

      final result = await sut.companyInfo(ticker);

      expect(result, CompanyInfo.empty(ticker.abreviation));
    });

    test('Should return empty company info if HttpClient.request returns without "assetProfile" field', () async {
      when(httpClient.request(url)).thenAnswer((_) async => jsonDecode('{"any_key":"any_value"}'));

      final result = await sut.companyInfo(ticker);

      expect(result, CompanyInfo.empty(ticker.abreviation));
    });

    test('Should return empty company info if HttpClient.request returns null "assetProfile" field', () async {
      when(httpClient.request(url)).thenAnswer((_) async => jsonDecode('{"assetProfile":null}'));

      final result = await sut.companyInfo(ticker);

      expect(result, CompanyInfo.empty(ticker.abreviation));
    });

    test('Should return empty company info if HttpClient.request returns an empty "assetProfile" field', () async {
      when(httpClient.request(url)).thenAnswer((_) async => jsonDecode('{"assetProfile": ""}'));

      final result = await sut.companyInfo(ticker);

      expect(result, CompanyInfo.empty(ticker.abreviation));
    });

    test('Should return empty company info if HttpClient.request returns an invalid "assetProfile" field', () async {
      when(httpClient.request(url)).thenAnswer((_) async => jsonDecode('{"assetProfile": {"any_key":"any_value"}}'));

      final result = await sut.companyInfo(ticker);

      expect(result, CompanyInfo.empty(ticker.abreviation));
    });

    test('Should throw if HttpClient.request throws', () async {
      when(httpClient.request(url)).thenThrow(Error());

      final future = sut.companyInfo(ticker);

      expect(future, throwsA(isA<Error>()));
    });
  });

  group('LoadStockPriceHistoryRepository', () {
    late Ticker ticker;
    late PriceInterval priceInterval;
    late List<HistoricalStockPrice> prices;

    setUp(() {
      httpClient = HttpClientSpy();
      priceInterval = PriceInterval.oneHour;
      ticker = Ticker('AAPL');
      prices = <HistoricalStockPrice>[
        HistoricalStockPrice(
          ticker: ticker.abreviation,
          at: DateTime.fromMillisecondsSinceEpoch(1628520300 * 1000),
          price: 146.06,
        ),
        HistoricalStockPrice(
          ticker: ticker.abreviation,
          at: DateTime.fromMillisecondsSinceEpoch(1628521200 * 1000),
          price: 145.85,
        ),
        HistoricalStockPrice(
          ticker: ticker.abreviation,
          at: DateTime.fromMillisecondsSinceEpoch(1628522100 * 1000),
          price: 146.09,
        ),
        HistoricalStockPrice(
          ticker: ticker.abreviation,
          at: DateTime.fromMillisecondsSinceEpoch(1628523000 * 1000),
          price: 146.03,
        ),
        HistoricalStockPrice(
          ticker: ticker.abreviation,
          at: DateTime.fromMillisecondsSinceEpoch(1628523900 * 1000),
          price: 146.14,
        ),
        HistoricalStockPrice(
          ticker: ticker.abreviation,
          at: DateTime.fromMillisecondsSinceEpoch(1628524800 * 1000),
          price: 146.00,
        ),
        HistoricalStockPrice(
          ticker: ticker.abreviation,
          at: DateTime.fromMillisecondsSinceEpoch(1628525700 * 1000),
          price: 145.84,
        ),
        HistoricalStockPrice(
          ticker: ticker.abreviation,
          at: DateTime.fromMillisecondsSinceEpoch(1628526600 * 1000),
          price: 145.86,
        ),
        HistoricalStockPrice(
          ticker: ticker.abreviation,
          at: DateTime.fromMillisecondsSinceEpoch(1628527500 * 1000),
          price: 145.85,
        ),
        HistoricalStockPrice(
          ticker: ticker.abreviation,
          at: DateTime.fromMillisecondsSinceEpoch(1628528400 * 1000),
          price: 145.00,
        ),
      ];
      sut = HttpStockRepository(httpClient);
      url = '/hi/history/${ticker.abreviation}/${priceInterval.description}';
      sutResult = jsonDecode(
        '{"meta":{"currency":"USD","symbol":"${ticker.abreviation}","exchangeName":"NMS","instrumentType":"EQUITY","firstTradeDate":345479400,"regularMarketTime":1631199340,"gmtoffset":-14400,"timezone":"EDT","exchangeTimezoneName":"America/New_York","regularMarketPrice":155.315,"chartPreviousClose":146.09,"previousClose":155.11,"scale":3,"priceHint":2,"dataGranularity":"15m","range":""},"items":{"1628520300":{"date":"09-08-2021","open":146.1,"high":146.19,"low":145.95,"close":146.06},"1628521200":{"date":"09-08-2021","open":146.06,"high":146.16,"low":145.79,"close":145.85},"1628522100":{"date":"09-08-2021","open":145.85,"high":146.15,"low":145.8,"close":146.09},"1628523000":{"date":"09-08-2021","open":146.1,"high":146.13,"low":145.91,"close":146.03},"1628523900":{"date":"09-08-2021","open":146.02,"high":146.15,"low":145.92,"close":146.14},"1628524800":{"date":"09-08-2021","open":146.14,"high":146.15,"low":145.91,"close":146},"1628525700":{"date":"09-08-2021","open":145.93,"high":146.01,"low":145.82,"close":145.84},"1628526600":{"date":"09-08-2021","open":145.85,"high":145.95,"low":145.79,"close":145.86},"1628527500":{"date":"09-08-2021","open":145.86,"high":145.97,"low":145.83,"close":145.85},"1628528400":{"date":"09-08-2021","open":145.85,"high":145.97,"low":145.81,"close":145}},"error":null}',
      );
      when(httpClient.request(url)).thenAnswer((_) async => sutResult);
    });

    test('Should call HttpClient with correct values', () async {
      await sut.priceHistory(
        ticker: ticker,
        priceInterval: priceInterval,
      );
      verify(httpClient.request(url)).called(1);
    });

    test('Should return HttpClient.request result converted to historical stock price', () async {
      final result = await sut.priceHistory(
        ticker: ticker,
        priceInterval: priceInterval,
      );

      expect(result, containsAll(prices));
      expect(result.length, prices.length);
    });

    test('Should return empty list if HttpClient.request returns empty', () async {
      when(httpClient.request(url)).thenAnswer((_) async => '');

      final result = await sut.priceHistory(
        ticker: ticker,
        priceInterval: priceInterval,
      );

      expect(result.length, 0);
    });

    test('Should return empty list if HttpClient.request returns null', () async {
      when(httpClient.request(url)).thenAnswer((_) async => null);

      final result = await sut.priceHistory(
        ticker: ticker,
        priceInterval: priceInterval,
      );

      expect(result.length, 0);
    });

    test('Should return empty list if HttpClient.request returns empty items object', () async {
      sutResult = jsonDecode(
        '{"meta":{"currency":"USD","symbol":"${ticker.abreviation}","exchangeName":"NMS","instrumentType":"EQUITY","firstTradeDate":345479400,"regularMarketTime":1631199340,"gmtoffset":-14400,"timezone":"EDT","exchangeTimezoneName":"America/New_York","regularMarketPrice":155.315,"chartPreviousClose":146.09,"previousClose":155.11,"scale":3,"priceHint":2,"dataGranularity":"15m","range":""},"items":{},"error":null}',
      );

      when(httpClient.request(url)).thenAnswer((_) async => sutResult);

      final result = await sut.priceHistory(
        ticker: ticker,
        priceInterval: priceInterval,
      );

      expect(result.length, 0);
    });

    test('Should return empty list if HttpClient.request returns without items field', () async {
      sutResult = jsonDecode(
        '{"meta":{"currency":"USD","symbol":"${ticker.abreviation}","exchangeName":"NMS","instrumentType":"EQUITY","firstTradeDate":345479400,"regularMarketTime":1631199340,"gmtoffset":-14400,"timezone":"EDT","exchangeTimezoneName":"America/New_York","regularMarketPrice":155.315,"chartPreviousClose":146.09,"previousClose":155.11,"scale":3,"priceHint":2,"dataGranularity":"15m","range":""},"error":null}',
      );

      when(httpClient.request(url)).thenAnswer((_) async => sutResult);

      final result = await sut.priceHistory(
        ticker: ticker,
        priceInterval: priceInterval,
      );

      expect(result.length, 0);
    });

    test('Should throw if HttpClient.request throws', () async {
      when(httpClient.request(url)).thenThrow(Error());

      final future = sut.priceHistory(
        ticker: ticker,
        priceInterval: priceInterval,
      );

      expect(future, throwsA(isA<Error>()));
    });
  });
}

class HttpClientSpy extends Mock implements HttpClient {
  @override
  Future<dynamic> request(String url) async {
    return super.noSuchMethod(
      Invocation.method(#request, [url]),
      returnValue: '',
    );
  }
}
