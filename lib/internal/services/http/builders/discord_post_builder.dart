import 'dart:convert';

import 'package:http/http.dart';
import 'package:mineral/internal/services/http/discord_http_request_dispatcher.dart';
import 'package:mineral/services/http/builders/post_builder.dart';
import 'package:mineral/services/http/contracts/http_response.dart';
import 'package:mineral/services/http/http_client.dart';
import 'package:mineral/services/http/http_request_dispatcher.dart';
import 'package:mineral/services/http/method_adapter.dart';

/// Builder for [BaseRequest] with [Request] or [MultipartRequest]
/// ```dart
/// final DiscordHttpClient client = DiscordHttpClient(baseUrl: '/');
/// final foo = await client.post('/foo')
///   .payload({'foo': 'bar'})
///   .files([MultipartFile.fromBytes('file', [1, 2, 3])])
///   .header('Content-Type', 'application/json')
///   .build();
/// ```
class DiscordPostBuilder extends PostBuilder implements MethodAdapter {
  final DiscordHttpRequestDispatcher _dispatcher;
  final Map<String, String> _headers = {};
  final Request _request;
  final List<MultipartFile> _files = [];
  dynamic _payload;

  DiscordPostBuilder(this._dispatcher, this._request): super(_dispatcher, _request);

  /// Add AuditLog to the [BaseRequest] headers
  /// [AuditLog] is a reason for the action
  /// Related to the official [Discord API](https://discord.com/developers/docs/resources/audit-log) documentation
  /// ```dart
  /// final DiscordHttpClient client = DiscordHttpClient(baseUrl: '/');
  /// final foo = await client.post('/foo')
  ///   .payload({'foo': 'bar'})
  ///   .auditLog('foo')
  ///   .build();
  /// ```
  DiscordPostBuilder auditLog (String? value) {
    if (value != null) {
      _headers.putIfAbsent('X-Audit-Log-Reason', () => value);
    }
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
  @override
  Future<HttpResponse> build () async {
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