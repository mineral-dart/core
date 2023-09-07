import 'dart:convert';

import 'package:http/http.dart';
import 'package:mineral/internal/either.dart';
import 'package:mineral/services/http/http_client.dart';

/// Builder for [BaseRequest] with [Request] or [MultipartRequest]
/// ```dart
/// final HttpClient client = HttpClient(baseUrl: '/');
/// final foo = await client.post('/foo')
///   .payload({'foo': 'bar'})
///   .files([MultipartFile.fromBytes('file', [1, 2, 3])])
///   .header('Content-Type', 'application/json')
///   .build();
/// ```
class PostBuilder {
  final Map<String, String> _headers = {};
  final HttpClient _httpClient;
  final Request _request;
  final List<MultipartFile> _files = [];
  dynamic _payload;

  PostBuilder(this._httpClient, this._request);

  /// Add payload to the [BaseRequest]
  /// ```dart
  /// final HttpClient client = HttpClient(baseUrl: '/');
  /// final foo = await client.post('/foo')
  ///   .payload({'foo': 'bar'})
  ///   .build();
  /// ```
  PostBuilder payload (dynamic fields) {
    _payload = fields;
    return this;
  }

  /// Add files to the [BaseRequest] with [MultipartFile]
  /// ```dart
  /// final HttpClient client = HttpClient(baseUrl: '/');
  /// final foo = await client.post('/foo')
  ///   .files([MultipartFile.fromBytes('file', [1, 2, 3])])
  ///   .build();
  /// ```
  PostBuilder files (List<MultipartFile> files) {
    _files.addAll(files);
    return this;
  }

  /// Add headers to the [BaseRequest]
  /// ```dart
  /// final HttpClient client = HttpClient(baseUrl: '/');
  /// final foo = await client.post('/foo')
  ///   .header('Content-Type', 'application/json')
  ///   .build();
  /// ```
  PostBuilder header (String key, String value) {
    _headers.putIfAbsent(key, () => value);
    return this;
  }

  /// Build the [BaseRequest] and send it to the [HttpClient]
  /// [BaseRequest] becomes [Request] if there are no files and [MultipartRequest] if there are files
  /// ```dart
  /// final HttpClient client = HttpClient(baseUrl: '/');
  /// final foo = await client.post('/foo/:id')
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

    return _httpClient.dispatcher.process(request);
  }
}