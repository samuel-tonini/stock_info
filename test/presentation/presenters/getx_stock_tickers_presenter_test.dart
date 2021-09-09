import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mockito/mockito.dart';
import 'package:stock_info/domain/models/models.dart';
import 'package:stock_info/domain/usecases/usecases.dart';
import 'package:stock_info/presentation/protocols/protocols.dart';

main() {
  late GetxStockTickersPresenter sut;
  late LoadStockTickersSpy loadStockTickers;

  setUp(() {
    loadStockTickers = LoadStockTickersSpy();
    sut = GetxStockTickersPresenter(loadStockTickers);

    when(loadStockTickers()).thenAnswer((_) async => <Ticker>[]);
  });

  test('Should call LoadStockTickers', () async {
    await sut.load();

    verify(loadStockTickers()).called(1);
  });

  test('Should emit error if LoadStockTickers throws', () async {
    when(loadStockTickers()).thenThrow(Error());

    expectLater(sut.tickersStream, emitsError(Error()));

    await sut.load();
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

class GetxStockTickersPresenter implements StockTickersPresenter {
  GetxStockTickersPresenter(this.loadStockTickers);

  final _tickers = Rx<List<String>>(<String>[]);
  final LoadStockTickers loadStockTickers;

  @override
  Stream<List<String>> get tickersStream => _tickers.stream;

  @override
  void goToCompanyInfo(String ticker) {}

  @override
  Future<void> load() async {
    try {
      await loadStockTickers();
    } catch (_) {
      _tickers.addError(
        Error(),
        StackTrace.empty,
      );
    }
  }
}
