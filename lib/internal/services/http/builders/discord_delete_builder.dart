import 'package:http/http.dart';
import 'package:mineral/internal/either.dart';
import 'package:mineral/internal/services/http/discord_http_request_dispatcher.dart';
import 'package:mineral/services/http/builders/delete_builder.dart';
import 'package:mineral/services/http/http_request_dispatcher.dart';
import 'package:mineral/services/http/method_adapter.dart';

/// Builder for [BaseRequest] with [Request]
/// ```dart
/// final DiscordDeleteBuilder client = DiscordDeleteBuilder(baseUrl: '/');
/// await client.delete('/foo').build();
/// ```
class DiscordDeleteBuilder extends DeleteBuilder implements MethodAdapter {
  final DiscordHttpRequestDispatcher _dispatcher;
  final Map<String, String> _headers = {};
  final Request _request;

  DiscordDeleteBuilder(this._dispatcher, this._request): super(_dispatcher, _request);

  /// Add AuditLog to the [BaseRequest] headers
  /// [AuditLog] is a reason for the action
  /// Related to the official [Discord API](https://discord.com/developers/docs/resources/audit-log) documentation
  /// ```dart
  /// final DiscordHttpClient client = DiscordHttpClient(baseUrl: '/');
  /// final foo = await client.delete('/foo')
  ///   .auditLog('foo')
  ///   .build();
  /// ```
  DiscordDeleteBuilder auditLog (String? value) {
    if (value != null) {
      _headers.putIfAbsent('X-Audit-Log-Reason', () => value);
    }
    return this;
  }

  /// Build the [BaseRequest] and send it to the [HttpClient]
  /// ```dart
  /// final DiscordHttpClient client = DiscordHttpClient(baseUrl: '/');
  /// final foo = await client.delete('/foo/:id').build();
  /// ```
  @override
  Future<EitherContract> build () async {
    _request.headers.addAll(_headers);
    return _dispatcher.process(_request);
  }
}