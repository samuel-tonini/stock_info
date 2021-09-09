import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:stock_info/domain/models/ticker.dart';

import 'package:stock_info/infra/http/http.dart';
import 'package:stock_info/infra/protocols/protocols.dart';

main() {
  late HttpStockRepository sut;
  late HttpClientSpy httpClient;
  late String url;
  late dynamic sutResult;

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
