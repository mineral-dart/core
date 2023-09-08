import 'package:http/http.dart';
import 'package:mineral/internal/either.dart';
import 'package:mineral/services/http/contracts/http_request_dispatcher_contract.dart';
import 'package:mineral/services/http/http_client.dart';
import 'package:mineral/services/http/http_request_dispatcher.dart';
import 'package:mineral/services/http/method_adapter.dart';

/// Builder for [BaseRequest] with [Request]
/// ```dart
/// final HttpClient client = HttpClient(baseUrl: '/');
/// final foo = await client.get('/foo').build();
/// ```
class GetBuilder<D extends HttpRequestDispatcherContract> extends MethodAdapter {
  final D _dispatcher;
  final Request _request;

  GetBuilder(this._dispatcher, this._request);

  /// Build the [BaseRequest] and send it to the [HttpClient]
  /// ```dart
  /// final HttpClient client = HttpClient(baseUrl: '/');
  /// final foo = await client.patch('/foo/:id').build();
  /// ```
  @override
  Future<EitherContract> build () async {
    return _dispatcher.process(_request);
  }
}