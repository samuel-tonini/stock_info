import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';

import '../protocols/protocols.dart';

class HttpAdapter implements HttpClient {
  HttpAdapter({
    required this.client,
    required this.baseUrl,
    required this.hostHeader,
    required this.keyHeader,
  });

  final Client client;
  final String baseUrl;
  final String hostHeader;
  final String keyHeader;

  @override
  Future<dynamic> request(String resourceUrl) async {
    final rawResponse = await client.get(
      Uri.parse('$baseUrl$resourceUrl'),
      headers: {
        HttpHeaders.acceptHeader: ContentType.json.value,
        HttpHeaders.contentTypeHeader: ContentType.json.value,
        'x-rapidapi-host': hostHeader,
        'x-rapidapi-key': keyHeader,
      },
    );
    if (rawResponse.statusCode < 200 || rawResponse.statusCode > 299) {
      throw HttpException(rawResponse.body);
    }
    return rawResponse.body.trim().isEmpty ? null : jsonDecode(rawResponse.body);
  }
}
