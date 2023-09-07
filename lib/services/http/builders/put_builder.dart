import 'dart:convert';

import 'package:http/http.dart';
import 'package:mineral/internal/either.dart';
import 'package:mineral/services/http/http_client.dart';
import 'package:mineral/services/http/http_request_dispatcher.dart';
import 'package:mineral/services/http/method_adapter.dart';

/// Builder for [BaseRequest] with [Request] or [MultipartRequest]
/// ```dart
/// final HttpClient client = HttpClient(baseUrl: '/');
/// final foo = await client.put('/foo')
///   .payload({'foo': 'bar'})
///   .files([MultipartFile.fromBytes('file', [1, 2, 3])])
///   .header('Content-Type', 'application/json')
///   .build();
/// ```
class PutBuilder extends MethodAdapter {
  final Map<String, String> _headers = {};
  final HttpRequestDispatcher _dispatcher;
  final Request _request;
  final List<MultipartFile> _files = [];
  dynamic _payload;

  PutBuilder(this._dispatcher, this._request);

  /// Add payload to the [BaseRequest]
  /// ```dart
  /// final HttpClient client = HttpClient(baseUrl: '/');
  /// final foo = await client.put('/foo/:id')
  ///   .payload({'foo': 'bar'})
  ///   .build();
  /// ```
  PutBuilder payload (dynamic fields) {
    _payload = fields;
    return this;
  }

  /// Add files to the [BaseRequest] with [MultipartFile]
  /// ```dart
  /// final HttpClient client = HttpClient(baseUrl: '/');
  /// final foo = await client.put('/foo/:id')
  ///   .files([MultipartFile.fromBytes('file', [1, 2, 3])])
  ///   .build();
  /// ```
  PutBuilder files (List<MultipartFile> files) {
    _files.addAll(files);
    return this;
  }

  /// Add headers to the [BaseRequest]
  /// ```dart
  /// final HttpClient client = HttpClient(baseUrl: '/');
  /// final foo = await client.put('/foo/:id')
  ///   .header('Content-Type', 'application/json')
  ///   .build();
  /// ```
  PutBuilder header (String key, String value) {
    _headers.putIfAbsent(key, () => value);
    return this;
  }

  /// Build the [BaseRequest] and send it to the [HttpClient]
  /// [BaseRequest] becomes [Request] if there are no files and [MultipartRequest] if there are files
  /// ```dart
  /// final HttpClient client = HttpClient(baseUrl: '/');
  /// final foo = await client.put('/foo/:id')
  ///   .payload({'foo': 'bar'})
  ///   .build();
  /// ```
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

    return _dispatcher.process(request);
  }
}