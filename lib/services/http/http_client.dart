import 'package:http/http.dart';
import 'package:mineral/services/http/builders/delete_builder.dart';
import 'package:mineral/services/http/builders/get_builder.dart';
import 'package:mineral/services/http/builders/patch_builder.dart';
import 'package:mineral/services/http/builders/post_builder.dart';
import 'package:mineral/services/http/builders/put_builder.dart';
import 'package:mineral/services/http/header_bucket.dart';
import 'package:mineral/services/http/http_request_dispatcher.dart';

/// HTTP Client used to make requests to a server
/// ```dart
/// final HttpClient client = HttpClient(baseUrl: '/');
/// ```
class HttpClient {
  /// Client used to make requests
  final Client _client = Client();

  /// Dispatcher used to dispatch requests under pools
  late final HttpRequestDispatcher dispatcher;

  /// Base URL of this
  final String baseUrl;

  /// Headers of this
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
  GetBuilder get(String url) {
    final request = Request('GET', Uri.parse('$baseUrl$url'))
      ..headers.addAll(headers.all);

    return GetBuilder(this, request);
  }

  /// Create a POST request
  /// ```dart
  /// final HttpClient client = HttpClient(baseUrl: '/');
  /// final foo = await client.post('/foo/:id')
  ///   .payload({ 'name': 'John Doe' })
  ///   .build();
  /// ```
  PostBuilder post(String url) {
    final request = Request('POST', Uri.parse('$baseUrl$url'))
      ..headers.addAll(headers.all);

    return PostBuilder(this, request);
  }

  /// Create a PUT request
  /// ```dart
  /// final HttpClient client = HttpClient(baseUrl: '/');
  /// final foo = await client.put('/foo/:id')
  ///  .payload({ 'name': 'John Doe' })
  ///  .build();
  ///  ```
  PutBuilder put(String url) {
    final request = Request('PUT', Uri.parse('$baseUrl$url'))
      ..headers.addAll(headers.all);

    return PutBuilder(this, request);
  }

  /// Create a PATCH request
  /// ```dart
  /// final HttpClient client = HttpClient(baseUrl: '/');
  /// final foo = await client.patch('/foo/:id')
  ///   .payload({ 'name': 'John Doe' })
  ///   .build();
  /// ```
  PatchBuilder patch(String url) {
    final request = Request('PATCH', Uri.parse('$baseUrl$url'))
      ..headers.addAll(headers.all);

    return PatchBuilder(this, request);
  }

  /// Create a DELETE request
  /// ```dart
  /// final HttpClient client = HttpClient(baseUrl: '/');
  /// await client.delete('/foo').build();
  /// ```
  DeleteBuilder delete(String url) {
    final request = Request('DELETE', Uri.parse('$baseUrl$url'))
      ..headers.addAll(headers.all);

    return DeleteBuilder(this, request);
  }
}