import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:mockito/mockito.dart';

import 'package:stock_info/infra/http/http.dart';

main() {
  late ClientSpy client;
  late String baseUrl;
  late String resourceUrl;
  late String response;
  late HttpAdapter sut;
  late Map<String, String> defaultHeaders;
  late String hostHeader;
  late String keyHeader;

  setUp(() {
    baseUrl = 'http://localhost:8080';
    resourceUrl = '/tr/trending';
    hostHeader = 'any_host';
    keyHeader = '123';
    defaultHeaders = {
      HttpHeaders.acceptHeader: ContentType.json.value,
      HttpHeaders.contentTypeHeader: ContentType.json.value,
      'x-rapidapi-host': hostHeader,
      'x-rapidapi-key': keyHeader,
    };
    client = ClientSpy();
    response = '{"any_key": "any_value"}';
    sut = HttpAdapter(
      client: client,
      baseUrl: baseUrl,
      hostHeader: hostHeader,
      keyHeader: keyHeader,
    );
    when(client.get(
      Uri.parse('$baseUrl$resourceUrl'),
      headers: defaultHeaders,
    )).thenAnswer(
      (_) async => Response(response, 200),
    );
  });

  test('Should call Client with correct values', () async {
    await sut.request(resourceUrl);

    verify(client.get(
      Uri.parse('$baseUrl$resourceUrl'),
      headers: defaultHeaders,
    )).called(1);
  });

  test('Should return Client response decoded', () async {
    final result = await sut.request(resourceUrl);

    expect(result, jsonDecode(response));
  });

  test('Should return null if Client response is empty', () async {
    when(client.get(
      Uri.parse('$baseUrl$resourceUrl'),
      headers: defaultHeaders,
    )).thenAnswer(
      (_) async => Response('', 200),
    );

    final result = await sut.request(resourceUrl);

    expect(result, isNull);
  });

  test('Should throw if Client throws', () async {
    when(client.get(
      Uri.parse('$baseUrl$resourceUrl'),
      headers: defaultHeaders,
    )).thenThrow(Error());

    final future = sut.request(resourceUrl);

    expect(future, throwsA(isA<Error>()));
  });

  test('Should throw if Client has http error code', () async {
    when(client.get(
      Uri.parse('$baseUrl$resourceUrl'),
      headers: defaultHeaders,
    )).thenAnswer(
      (_) async => Response('', 500),
    );

    final future = sut.request(resourceUrl);

    expect(future, throwsA(isA<HttpException>()));
  });
}

class ClientSpy extends Mock implements Client {
  @override
  Future<Response> get(Uri url, {Map<String, String>? headers}) async {
    return super.noSuchMethod(
      Invocation.method(#get, [url], {#headers: headers}),
      returnValue: Response('', 200),
    );
  }
}
