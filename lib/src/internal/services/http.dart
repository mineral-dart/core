import 'dart:convert';
import 'dart:isolate';

import 'package:http/http.dart' as http;
import 'package:mineral/console.dart';

class Http {
  String baseUrl;
  final Map<String, String> _headers = {};

  Http({ required this.baseUrl });

  void defineHeader ({ required String header, required String value }) {
    _headers.putIfAbsent(header, () => value);
  }

  void removeHeader (String header) {
    _headers.remove(header);
  }

  Future<http.Response> get ({ required String url, Map<String, String>? headers }) async {
    http.Response response = await createIsolateRequest(() => http.get(Uri.parse("$baseUrl$url"), headers: _getHeaders(headers)));

    if (response.statusCode == 429) {
      return _retryAfter(response, () => get(url: url, headers: _getHeaders(headers)));
    }

    return response;
  }

  Future<http.Response> post ({ required String url, required dynamic payload, Map<String, String>? headers }) async {
    http.Response response = await createIsolateRequest(() => http.post(Uri.parse("$baseUrl$url"),
      body: jsonEncode(payload),
      headers: _getHeaders(headers)
    ));

    if (response.statusCode == 429) {
      return _retryAfter(response, () => post(url: url, payload: payload, headers: _getHeaders(headers)));
    }

    return response;
  }

  Future<http.Response> put ({ required String url, required dynamic payload, Map<String, String>? headers }) async {
    http.Response response = await createIsolateRequest(() => http.put(Uri.parse("$baseUrl$url"),
      body: jsonEncode(payload),
      headers: _getHeaders(headers))
    );

    if (response.statusCode == 429) {
      return _retryAfter(response, () => put(url: url, payload: payload, headers: _getHeaders(headers)));
    }

    return response;
  }

  Future<http.Response> patch ({ required String url, required dynamic payload, Map<String, String>? headers }) async {
    http.Response response = await createIsolateRequest(() => http.patch(Uri.parse("$baseUrl$url"),
      body: jsonEncode(payload),
      headers: _getHeaders(headers))
    );

    if (response.statusCode == 429) {
      return _retryAfter(response, () => patch(url: url, payload: payload, headers: _getHeaders(headers)));
    }

    return response;
  }

  Future<http.Response> destroy ({ required String url, Map<String, String>? headers }) async {
    http.Response response = await createIsolateRequest(() => http.delete(Uri.parse("$baseUrl$url"), headers: _getHeaders(headers)));

    if (response.statusCode == 429) {
      return _retryAfter(response, () => destroy(url: url, headers: _getHeaders(headers)));
    }

    return response;
  }

  Map<String, String> _getHeaders (Map<String, String>? headers) {
    Map<String, String> map = Map.from(_headers);

    if (headers != null) {
      map.addAll(headers);
    }

    return map;
  }

  Future<http.Response> _retryAfter (http.Response response, Future<http.Response> Function() task) async {
    int retryAfter = jsonDecode(response.body)['retry_after'];
    Console.warn(message: 'You have been rate limited, please try again in $retryAfter seconds');

    return await createIsolateRequest(() => Future.delayed(Duration(seconds: retryAfter), task));
  }

  createIsolateRequest (dynamic task) async {
    final port = ReceivePort();

    await Isolate.spawn((dynamic message) async {
      final port = message['port'];
      final task = message['task'];

      Isolate.exit(port, await task());
    }, { 'port': port.sendPort, 'task': task });

    return await port.first;
  }
}
