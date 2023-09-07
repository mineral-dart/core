import 'package:http/http.dart';
import 'package:mineral/internal/either.dart';
import 'package:mineral/services/http/http_client.dart';

/// Builder for [BaseRequest] with [Request]
/// ```dart
/// final HttpClient client = HttpClient(baseUrl: '/');
/// await client.delete('/foo').build();
/// ```
class DeleteBuilder {
  final HttpClient _httpClient;
  final Request _request;

  DeleteBuilder(this._httpClient, this._request);

  /// Build the [BaseRequest] and send it to the [HttpClient]
  /// ```dart
  /// final HttpClient client = HttpClient(baseUrl: '/');
  /// final foo = await client.patch('/foo/:id').build();
  /// ```
  Future<EitherContract> build () async {
    return _httpClient.dispatcher.process(_request);
  }
}