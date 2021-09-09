import 'package:flutter_test/flutter_test.dart';

import 'package:stock_info/domain/models/models.dart';

main() {
  late HistoricalStockPrice sut;
  late String ticker;
  late DateTime at;
  late double price;

  setUp(() {
    ticker = 'AAPL';
    at = DateTime.fromMillisecondsSinceEpoch(1587475800 * 1000);
    price = 272.37;
    sut = HistoricalStockPrice(
      ticker: ticker,
      at: at,
      price: price,
    );
  });

  test('Should populate properties with correct values', () {
    expect(sut.ticker, ticker);
    expect(sut.at, at);
    expect(sut.price, price);
  });

  test('Should compare using its data', () {
    expect(sut, equals(HistoricalStockPrice(ticker: ticker, at: at, price: price)));
  });

  test('Should throw if ticker is empty', () {
    expect(
      () {
        return HistoricalStockPrice(
          ticker: '',
          at: DateTime.fromMillisecondsSinceEpoch(0),
          price: 0.0,
        );
      },
      throwsA(isA<ArgumentError>()),
    );
  });
}
