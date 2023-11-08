import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:mineral/api/http/header.dart';
import 'package:mineral/api/http/http_client_option.dart';
import 'package:mineral/api/http/response.dart';

abstract interface class HttpClient {
  abstract final HttpClientOption option;

  Future<Response> get(String endpoint, {Set<Header> headers});

  Future<Response> post(String endpoint, {Set<Header> headers, Map<String, dynamic> body});

  Future<Response> put(String endpoint, {Set<Header> headers, Map<String, dynamic> body});

  Future<Response> patch(String endpoint, {Set<Header> headers, Map<String, dynamic> body});

  Future<Response> delete(String endpoint, {Set<Header> headers});
}

final class HttpClientImpl implements HttpClient {
  final http.Client _client = http.Client();

  @override
  final HttpClientOption option;

  HttpClientImpl({required this.option});

  @override
  Future<Response> delete(String endpoint, {Set<Header> headers = const {}}) {
    return _request('DELETE', endpoint, headers, null);
  }

  @override
  Future<Response> get(String endpoint, {Set<Header> headers = const {}}) async {
    return _request('GET', endpoint, headers, null);
  }

  @override
  Future<Response> patch(String endpoint,
      {Set<Header> headers = const {}, Map<String, dynamic>? body}) {
    return _request('PATCH', endpoint, headers, null);
  }

  @override
  Future<Response> post(String endpoint,
      {Set<Header> headers = const {}, Map<String, dynamic>? body}) {
    return _request('POST', endpoint, headers, null);
  }

  @override
  Future<Response> put(String endpoint,
      {Set<Header> headers = const {}, Map<String, dynamic>? body}) {
    return _request('PUT', endpoint, headers, body);
  }

  Future<Response> _request(
      String method, String endpoint, Set<Header> headers, Map<String, dynamic>? body) async {
    final request = http.Request(method, Uri.parse('${option.baseUrl}$endpoint'))
      ..headers.addAll(_serializeHeaders(headers))
      ..body = jsonEncode(body);

    final http.StreamedResponse streamedResponse = await _client.send(request);
    final http.Response response = await http.Response.fromStream(streamedResponse);

    return ResponseImpl.fromHttpResponse(response);
  }

  Map<String, String> _serializeHeaders(Set<Header> headers) {
    final Set<Header> mergedHeaders = {...option.headers, ...headers};
    return mergedHeaders
        .fold({}, (previousValue, element) => {...previousValue, element.key: element.value});
  }
}
