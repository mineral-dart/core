import 'package:mineral/api/http/header.dart';
import 'package:mineral/api/http/http_client.dart';
import 'package:mineral/api/http/http_request_option.dart';
import 'package:mineral/api/http/response.dart';

final class HttpRequestBuilder {
  final HttpClient _client;

  String _endpoint = '';
  String _method = '';
  Map<String, String> _queryParameters = {};
  Set<Header> _headers = {};
  Map<String, dynamic> _body = {};

  HttpRequestBuilder(this._client);

  HttpRequestBuilder setHeader(Header header) {
    _headers.add(header);
    return this;
  }

  HttpRequestBuilder setHeaders(Set<Header> headers) {
    _headers = headers;
    return this;
  }

  HttpRequestBuilder setUrlParameter(String key, dynamic value) {
    _queryParameters[key] = value;
    return this;
  }

  HttpRequestBuilder setUrlParameters(Map<String, String> parameters) {
    _queryParameters = parameters;
    return this;
  }

  HttpRequestBuilder body(Map<String, dynamic> body) {
    _body = body;
    return this;
  }

  HttpRequestBuilder get(String endpoint) {
    _method = 'GET';
    _endpoint = endpoint;
    return this;
  }

  HttpRequestBuilder post(String endpoint) {
    _method = 'POST';
    _endpoint = endpoint;
    return this;
  }

  HttpRequestBuilder put(String endpoint) {
    _method = 'PUT';
    _endpoint = endpoint;
    return this;
  }

  HttpRequestBuilder patch(String endpoint) {
    _method = 'PATCH';
    _endpoint = endpoint;
    return this;
  }

  HttpRequestBuilder delete(String endpoint) {
    _method = 'DELETE';
    _endpoint = endpoint;
    return this;
  }

  HttpRequestBuilder method(String method, String endpoint) {
    _method = method;
    _endpoint = endpoint;
    return this;
  }

  Future<Response<T>> build<T>() async {
    return _client.send<T>(_method, _endpoint,
        option: HttpRequestOptionImpl(headers: _headers, queryParameters: _queryParameters),
        body: _body);
  }
}
