import 'package:http/http.dart';
import 'package:mineral/services/http/builders/delete_builder.dart';
import 'package:mineral/services/http/builders/get_builder.dart';
import 'package:mineral/services/http/builders/patch_builder.dart';
import 'package:mineral/services/http/builders/post_builder.dart';
import 'package:mineral/services/http/builders/put_builder.dart';
import 'package:mineral/services/http/header_bucket.dart';
import 'package:mineral/services/http/http_client_contract.dart';
import 'package:mineral/services/http/http_request_dispatcher.dart';
import 'package:mineral/services/http/method_adapter.dart';

/// HTTP Client used to make requests to a server
/// ```dart
/// final HttpClient client = HttpClient(baseUrl: '/');
/// ```
class HttpClient<T extends MethodAdapter> implements HttpClientContract {
  /// Client used to make requests
  final Client _client = Client();

  /// Dispatcher used to dispatch requests under pools
  @override
  late final HttpRequestDispatcher dispatcher;

  /// Base URL of this
  @override
  final String baseUrl;

  /// Headers of this
  @override
  final HeaderBucket headers = HeaderBucket();

  HttpClient({ required this.baseUrl, Map<String, String> headers = const {} }) {
    dispatcher = HttpRequestDispatcher(_client);
    this.headers.addAll(headers);
  }

  /// Create a GET request
  /// ```dart
  /// final HttpClient client = HttpClient(baseUrl: '/');
  /// final response = await client.get('/foo').build();
  /// ```
  @override
  GetBuilder get(String url) {
    final request = Request('GET', Uri.parse('$baseUrl$url'))
      ..headers.addAll(headers.all);

    return GetBuilder(dispatcher, request);
  }

  /// Create a POST request
  /// ```dart
  /// final HttpClient client = HttpClient(baseUrl: '/');
  /// final foo = await client.post('/foo/:id')
  ///   .payload({ 'name': 'John Doe' })
  ///   .build();
  /// ```
  @override
  PostBuilder post(String url) {
    final request = Request('POST', Uri.parse('$baseUrl$url'))
      ..headers.addAll(headers.all);

    return PostBuilder(dispatcher, request);
  }

  /// Create a PUT request
  /// ```dart
  /// final HttpClient client = HttpClient(baseUrl: '/');
  /// final foo = await client.put('/foo/:id')
  ///  .payload({ 'name': 'John Doe' })
  ///  .build();
  ///  ```
  @override
  PutBuilder put(String url) {
    final request = Request('PUT', Uri.parse('$baseUrl$url'))
      ..headers.addAll(headers.all);

    return PutBuilder(dispatcher, request);
  }

  /// Create a PATCH request
  /// ```dart
  /// final HttpClient client = HttpClient(baseUrl: '/');
  /// final foo = await client.patch('/foo/:id')
  ///   .payload({ 'name': 'John Doe' })
  ///   .build();
  /// ```
  @override
  PatchBuilder patch(String url) {
    final request = Request('PATCH', Uri.parse('$baseUrl$url'))
      ..headers.addAll(headers.all);

    return PatchBuilder(dispatcher, request);
  }

  /// Create a DELETE request
  /// ```dart
  /// final HttpClient client = HttpClient(baseUrl: '/');
  /// await client.delete('/foo/:id').build();
  /// ```
  @override
  DeleteBuilder delete(String url) {
    final request = Request('DELETE', Uri.parse('$baseUrl$url'))
      ..headers.addAll(headers.all);

    return DeleteBuilder(dispatcher, request);
  }
}