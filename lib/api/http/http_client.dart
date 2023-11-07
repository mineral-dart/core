import 'package:http/http.dart' as http;
import 'package:mineral/api/http/header.dart';
import 'package:mineral/api/http/http_client_option.dart';
import 'package:mineral/api/http/http_method.dart';
import 'package:mineral/api/http/request_processor.dart';
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
  final RequestProcessor processor = RequestProcessor();
  final http.Client _client = http.Client();

  @override
  final HttpClientOption option;

  HttpClientImpl({required this.option});

  @override
  Future<Response> delete(String endpoint, {Set<Header> headers = const {}}) {
    return processor.process(
        _client, HttpMethodImpl.delete, option, _getUri(endpoint), headers, null);
  }

  @override
  Future<Response> get(String endpoint, {Set<Header> headers = const {}}) async {
    return processor.process(_client, HttpMethodImpl.get, option, _getUri(endpoint), headers, null);
  }

  @override
  Future<Response> patch(String endpoint,
      {Set<Header> headers = const {}, Map<String, dynamic>? body}) {
    return processor.process(
        _client, HttpMethodImpl.patch, option, _getUri(endpoint), headers, body);
  }

  @override
  Future<Response> post(String endpoint,
      {Set<Header> headers = const {}, Map<String, dynamic>? body}) {
    return processor.process(
        _client, HttpMethodImpl.post, option, _getUri(endpoint), headers, body);
  }

  @override
  Future<Response> put(String endpoint,
      {Set<Header> headers = const {}, Map<String, dynamic>? body}) {
    return processor.process(
        _client, HttpMethodImpl.delete, option, _getUri(endpoint), headers, body);
  }

  Uri _getUri(String endpoint) {
    return Uri.parse('${option.baseUrl}$endpoint');
  }
}
