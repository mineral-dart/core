import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:mineral/api/http/header.dart';
import 'package:mineral/api/http/http_client_config.dart';
import 'package:mineral/api/http/http_interceptor.dart';
import 'package:mineral/api/http/http_request_option.dart';
import 'package:mineral/api/http/response.dart';

abstract interface class HttpClient {
  HttpInterceptor get interceptor;

  HttpClientConfig get config;

  Future<Response<T>> get<T>(String endpoint, {HttpRequestOption? option});

  Future<Response<T>> post<T>(String endpoint,
      {HttpRequestOption? option, Map<String, dynamic> body});

  Future<Response<T>> put<T>(String endpoint,
      {HttpRequestOption? option, Map<String, dynamic> body});

  Future<Response<T>> patch<T>(String endpoint,
      {HttpRequestOption? option, Map<String, dynamic> body});

  Future<Response<T>> delete<T>(String endpoint, {HttpRequestOption? option});
}

final class HttpClientImpl implements HttpClient {
  final http.Client _client = http.Client();

  @override
  final HttpInterceptor interceptor = HttpInterceptorImpl();

  @override
  final HttpClientConfig config;

  HttpClientImpl({required this.config});

  @override
  Future<Response<T>> delete<T>(String endpoint, {HttpRequestOption? option}) {
    return _request<T>('DELETE', endpoint, option, null);
  }

  @override
  Future<Response<T>> get<T>(String endpoint, {HttpRequestOption? option}) async {
    return _request('GET', endpoint, option, null);
  }

  @override
  Future<Response<T>> patch<T>(String endpoint,
      {HttpRequestOption? option, Map<String, dynamic>? body}) {
    return _request('PATCH', endpoint, option, body);
  }

  @override
  Future<Response<T>> post<T>(String endpoint,
      {HttpRequestOption? option, Map<String, dynamic>? body}) {
    return _request('POST', endpoint, option, body);
  }

  @override
  Future<Response<T>> put<T>(String endpoint,
      {HttpRequestOption? option, Map<String, dynamic>? body}) {
    return _request('PUT', endpoint, option, body);
  }

  Future<Response<T>> _request<T>(
      String method, String endpoint, HttpRequestOption? option, Map<String, dynamic>? body) async {
    String url = '${config.baseUrl}$endpoint';

    if (option case HttpRequestOption(queryParameters: final params)) {
      url += '?${Uri(queryParameters: params).query}';
    }

    http.Request request = http.Request(method, Uri.parse(url))
      ..headers.addAll(_serializeHeaders(option?.headers ?? {}))
      ..body = jsonEncode(body);

    for (final requestInterceptor in interceptor.request) {
      request = await requestInterceptor(request);
    }

    final http.StreamedResponse streamedResponse = await _client.send(request);
    final http.Response res = await http.Response.fromStream(streamedResponse);

    Response response = ResponseImpl.fromHttpResponse(res);

    for (final handle in interceptor.response) {
      response = await handle(response);
    }

    return response as Response<T>;
  }

  Map<String, String> _serializeHeaders(Set<Header> headers) {
    final Set<Header> mergedHeaders = {...config.headers, ...headers};
    return mergedHeaders
        .fold({}, (previousValue, element) => {...previousValue, element.key: element.value});
  }
}
