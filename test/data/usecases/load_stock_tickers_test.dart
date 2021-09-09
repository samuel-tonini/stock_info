import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:stock_info/data/protocols/protocols.dart';
import 'package:stock_info/data/usecases/usecases.dart';

import 'package:stock_info/domain/models/models.dart';

main() {
  late LoadStockTickersUsecase sut;
  late LoadStockTickersRepositorySpy loadStockTickersRepository;

  setUp(() {
    loadStockTickersRepository = LoadStockTickersRepositorySpy();
    sut = LoadStockTickersUsecase(loadStockTickersRepository);
    when(loadStockTickersRepository.loadTickers()).thenAnswer((_) async {
      return <Ticker>[
        Ticker('^VIX'),
        Ticker('HIVE.V'),
        Ticker('MITT'),
        Ticker('LULU'),
        Ticker('AAPL'),
        Ticker('AMZO'),
      ];
    });
  });

  test('Should call LoadStockTickersRepository.loadTickers with correct value', () async {
    await sut();
    verify(loadStockTickersRepository.loadTickers()).called(1);
  });

  test('Should return tickers with alpha values only', () async {
    final result = await sut();
    expect(
      result,
      isNot(containsAll([
        Ticker('^VIX'),
        Ticker('HIVE.V'),
      ])),
    );
  });

  test('Should return LoadStockTickersRepository.loadTickers result value', () async {
    final result = await sut();
    expect(
      result,
      containsAll([
        Ticker('MITT'),
        Ticker('LULU'),
        Ticker('AAPL'),
        Ticker('AMZO'),
      ]),
    );
    expect(result.length, 4);
  });

  test('Should return tickers in alphabetical order', () async {
    final result = await sut();
    expect(
      result,
      containsAllInOrder([
        Ticker('AAPL'),
        Ticker('AMZO'),
        Ticker('LULU'),
        Ticker('MITT'),
      ]),
    );
    expect(result.length, 4);
  });

  test('Should throw if LoadStockTickersRepository.loadTickers throws', () async {
    when(loadStockTickersRepository.loadTickers()).thenThrow(Error());
    final future = sut();
    expect(future, throwsA(isA<Error>()));
  });
}

class LoadStockTickersRepositorySpy extends Mock implements LoadStockTickersRepository {
  @override
  Future<List<Ticker>> loadTickers() async {
    return super.noSuchMethod(
      Invocation.method(#loadTickers, []),
      returnValue: Future.value(<Ticker>[]),
    );
  }
}
