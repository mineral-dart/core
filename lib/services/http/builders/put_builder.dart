import 'dart:convert';

import 'package:http/http.dart';
import 'package:mineral/internal/either.dart';
import 'package:mineral/services/http/http_client.dart';

class PutBuilder {
  final Map<String, String> _headers = {};
  final HttpClient _httpClient;
  final Request _request;
  final List<MultipartFile> _files = [];
  dynamic _payload;

  PutBuilder(this._httpClient, this._request);

  PutBuilder payload (dynamic fields) {
    _payload = fields;
    return this;
  }

  PutBuilder files (List<MultipartFile> files) {
    _files.addAll(files);
    return this;
  }

  PutBuilder header (String key, String value) {
    _headers.putIfAbsent(key, () => value);
    return this;
  }

  Future<EitherContract> build () async {
    final BaseRequest request = _files.isNotEmpty
      ? MultipartRequest(_request.method, _request.url)
      : _request;

    if (request is MultipartRequest) {
      request.files.addAll(_files);
      request.fields.addAll(_payload);
      request.headers.addAll(_headers);
    }

    if (request is Request) {
      request.body = jsonEncode(_payload);
      request.headers.addAll(_headers);
    }

    return _httpClient.dispatcher.process(request);
  }
}