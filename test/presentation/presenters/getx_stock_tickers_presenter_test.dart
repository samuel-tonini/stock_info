import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mockito/mockito.dart';

import 'package:stock_info/domain/models/models.dart';
import 'package:stock_info/domain/usecases/usecases.dart';

import 'package:stock_info/presentation/presenters/presenters.dart';

import '../helpers/helpers.dart';

main() {
  late GetxStockTickersPresenter sut;
  late LoadStockTickersSpy loadStockTickers;
  late List<Ticker> tickers;
  late List<String> tickersStr;

  setUp(() {
    loadStockTickers = LoadStockTickersSpy();
    sut = GetxStockTickersPresenter(loadStockTickers);
    tickers = [
      Ticker('AAPL'),
      Ticker('AMZO'),
      Ticker('LULU'),
      Ticker('MITT'),
    ];
    tickersStr = tickers.map((ticker) => ticker.abreviation).toList();
    when(loadStockTickers()).thenAnswer((_) async => tickers);
  });

  test('Should call LoadStockTickers', () async {
    await sut.load();

    verify(loadStockTickers()).called(1);
  });

  test('Should emit error if LoadStockTickers throws', () async {
    when(loadStockTickers()).thenThrow(Error());

    expectLater(sut.tickersStream, emitsInOrder([[], emitsError(isA<Error>())]));

    await sut.load();
  });

  test('Should emit empty list and after the result', () async {
    expectLater(sut.tickersStream, emitsInOrder([[], tickersStr]));

    await sut.load();
  });

  testWidgets('Should call Get with correct value', (tester) async {
    await tester.pumpWidget(
      makePages(
        path: '/company_info/:ticker',
        page: () => Scaffold(
          appBar: AppBar(title: Text('any_title')),
          body: Text('any_page'),
        ),
        goToPath: false,
      ),
    );

    expect('/any_route', Get.currentRoute);

    sut.goToCompanyInfo('AAPL');
    await tester.pumpAndSettle();

    expect('/company_info/AAPL', Get.currentRoute);
  });
}

class LoadStockTickersSpy extends Mock implements LoadStockTickers {
  Future<List<Ticker>> call() async {
    return super.noSuchMethod(
      Invocation.method(#call, []),
      returnValue: <Ticker>[],
    );
  }
}
