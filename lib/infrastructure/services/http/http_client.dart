import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:mineral/infrastructure/services/http/header.dart';
import 'package:mineral/infrastructure/services/http/http_client_config.dart';
import 'package:mineral/infrastructure/services/http/http_client_status.dart';
import 'package:mineral/infrastructure/services/http/http_interceptor.dart';
import 'package:mineral/infrastructure/services/http/http_request_option.dart';
import 'package:mineral/infrastructure/services/http/request.dart';
import 'package:mineral/infrastructure/services/http/response.dart';

abstract interface class HttpClientContract {
  HttpClientStatus get status;

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

  Future<Response<T>> send<T>(String method, String endpoint,
      {HttpRequestOption? option, Map<String, dynamic> body});
}

final class HttpClient implements HttpClientContract {
  final http.Client _client = http.Client();

  @override
  final HttpClientStatus status = HttpClientStatusImpl();

  @override
  final HttpInterceptor interceptor = HttpInterceptorImpl();

  @override
  final HttpClientConfig config;

  HttpClient({required this.config});

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
      {HttpRequestOption? option, Object? body}) {
    return _request('PATCH', endpoint, option, body);
  }

  @override
  Future<Response<T>> post<T>(String endpoint,
      {HttpRequestOption? option, Object? body}) {
    return _request('POST', endpoint, option, body);
  }

  @override
  Future<Response<T>> put<T>(String endpoint,
      {HttpRequestOption? option, Object? body}) {
    return _request('PUT', endpoint, option, body);
  }

  @override
  Future<Response<T>> send<T>(String method, String endpoint,
      {HttpRequestOption? option, Object? body}) {
    return _request(method, endpoint, option, body);
  }

  Future<Response<T>> _request<T>(
      String method, String endpoint, HttpRequestOption? option, Object? body) async {
    String url = '${config.baseUrl}$endpoint';

    if (option case HttpRequestOption(queryParameters: final params)) {
      url += '?${Uri(queryParameters: params).query}';
    }

    Request request = RequestImpl(
      url: Uri.parse(url),
      body: body,
      bodyString: body != null ? jsonEncode(body) : '',
      headers: {...config.headers, ...option?.headers ?? {}},
      method: method,
    );

    for (final requestInterceptor in interceptor.request) {
      request = await requestInterceptor(request);
    }

    final http.Request httpRequest = http.Request(request.method, request.url)
      ..headers.addAll(_serializeHeaders(request.headers))
      ..body = request.body != null ? jsonEncode(request.body) : '';

    final http.StreamedResponse streamedResponse = await _client.send(httpRequest);
    final http.Response res = await http.Response.fromStream(streamedResponse);

    Response response = ResponseImpl.fromHttpResponse(res);
    print(jsonEncode(request.body));

    for (final handle in interceptor.response) {
      response = await handle(response);
    }

    return response as Response<T>;
  }

  Map<String, String> _serializeHeaders(Set<Header> headers) {
    return headers
        .fold({}, (previousValue, element) => {...previousValue, element.key: element.value});
  }
}
