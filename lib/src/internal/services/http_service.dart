import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:mineral/exception.dart';
import 'package:mineral/src/helper.dart';
import 'package:mineral_ioc/ioc.dart';

class HttpService extends MineralService {
  String baseUrl;
  final Map<String, String> _headers = {};

  HttpService({ required this.baseUrl });

  void defineHeader ({ required String header, required String value }) {
    _headers.putIfAbsent(header, () => value);
  }

  void removeHeader (String header) {
    _headers.remove(header);
  }

  Future<http.Response> get ({ required String url, Map<String, String>? headers }) async {
    final response = await http.get(Uri.parse("$baseUrl$url"), headers: _getHeaders(headers));
    return responseWrapper(response);
  }

  RequestBuilder post ({ required String url }) => RequestBuilder(HttpMethod.post, baseUrl, url, _headers, (http.Response response) => responseWrapper(response));

  RequestBuilder put ({ required String url }) => RequestBuilder(HttpMethod.put, baseUrl, url, _headers, (http.Response response) => responseWrapper(response));

  RequestBuilder patch ({ required String url }) => RequestBuilder(HttpMethod.patch, baseUrl, url, _headers, (http.Response response) => responseWrapper(response));

  Future<http.Response> destroy ({ required String url, Map<String, String>? headers }) async {
    final response = await http.delete(Uri.parse("$baseUrl$url"), headers: _getHeaders(headers));
    return responseWrapper(response);
  }

  Map<String, String> _getHeaders (Map<String, String>? headers) {
    Map<String, String> map = Map.from(_headers);

    if (headers != null) {
      map.addAll(headers);
    }

    return map;
  }

  http.Response responseWrapper<T> (http.Response response) {
    if (response.statusCode == 400) {
      final dynamic payload = jsonDecode(response.body);

      if (Helper.hasKey('components', payload)) {
        final List components = payload['components'];

        throw ApiException(payload['components'].length > 1
          ? '${response.statusCode} : components at ${components.join(', ')} positions are invalid'
          : '${response.statusCode} : the component at position ${components.first} is invalid'
        );
      }

      if (Helper.hasKey('embeds', payload)) {
        final List<int> components = payload['embeds'];

        throw ApiException(payload['embeds'].length > 1
          ? '${response.statusCode} embeds at ${components.join(', ')} positions are invalid'
          : '${response.statusCode} the embed at position ${components.first} is invalid'
        );
      }

      throw HttpException('${response.statusCode} : ${response.body}');
    }

    return response;
  }
}

enum HttpMethod {
  get('GET'),
  post('POST'),
  put('PUT'),
  patch('PATCH'),
  destroy('DELETE');

  final String uid;
  const HttpMethod(this.uid);
}

class RequestBuilder {
  final HttpMethod _method;
  final String _baseUrl;
  final String _url;
  final List<http.MultipartFile> _files = [];
  dynamic _payload;
  final Map<String, String> _headers;

  final dynamic Function(http.Response response) _responseWrapper;

  RequestBuilder(this._method, this._baseUrl, this._url, this._headers, this._responseWrapper);

  RequestBuilder payload (dynamic fields) {
    _payload = fields;
    return this;
  }

  RequestBuilder files (List<http.MultipartFile> files) {
    _files.addAll(files);
    return this;
  }

  RequestBuilder headers (Map<String, String> headers) {
    _headers.addAll(headers);
    return this;
  }

  Future<http.Response> build () async {
    final Map<String, String> fields = {};
    http.StreamedResponse response;

    if (_files.isNotEmpty) {
      fields.putIfAbsent('payload_json', () => jsonEncode(_payload));

      final request = http.MultipartRequest(_method.uid, Uri.parse('$_baseUrl$_url'))
        ..files.addAll(_files)
        ..fields.addAll(fields)
        ..headers.addAll(_headers);

      response = await request.send();
    } else {
      final request = http.Request(_method.uid, Uri.parse('$_baseUrl$_url'))
        ..body = jsonEncode(_payload)
        ..headers.addAll(_headers);

      response = await request.send();
    }

    return _responseWrapper(http.Response.bytes(await response.stream.toBytes(), response.statusCode));
  }
}