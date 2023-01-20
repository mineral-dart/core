import 'dart:convert';

import 'package:http/http.dart';
import 'package:mineral/src/internal/services/http_service/http_method.dart';

class RequestBuilder {
  final HttpMethod _method;
  final String _baseUrl;
  final String _url;
  final List<MultipartFile> _files = [];
  dynamic _payload;
  final Map<String, String> _headers;

  final dynamic Function(Response response) _responseWrapper;

  RequestBuilder(this._method, this._baseUrl, this._url, this._headers, this._responseWrapper);

  RequestBuilder payload (dynamic fields) {
    _payload = fields;
    return this;
  }

  RequestBuilder files (List<MultipartFile> files) {
    _files.addAll(files);
    return this;
  }

  RequestBuilder headers (Map<String, String> headers) {
    _headers.addAll(headers);
    return this;
  }

  RequestBuilder auditLog (String? value) {
    if (value != null) {
      _headers.putIfAbsent('X-Audit-Log-Reason', () => value);
    }
    return this;
  }

  Future<Response> build () async {
    final Map<String, String> fields = {};
    StreamedResponse response;

    if (_files.isNotEmpty) {
      fields.putIfAbsent('payload_json', () => jsonEncode(_payload));

      final request = MultipartRequest(_method.uid, Uri.parse('$_baseUrl$_url'))
        ..files.addAll(_files)
        ..fields.addAll(fields)
        ..headers.addAll(_headers);

      response = await request.send();
    } else {
      final request = Request(_method.uid, Uri.parse('$_baseUrl$_url'))
        ..body = jsonEncode(_payload)
        ..headers.addAll(_headers);

      response = await request.send();
    }

    return _responseWrapper(Response.bytes(await response.stream.toBytes(), response.statusCode));
  }
}