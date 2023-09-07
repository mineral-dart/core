import 'package:mineral/services/http/header_bucket.dart';
import 'package:mineral/services/http/http_request_dispatcher.dart';
import 'package:mineral/services/http/method_adapter.dart';

abstract class HttpClientContract {
  /// Dispatcher used to dispatch requests under pools
  late final HttpRequestDispatcher dispatcher;

  /// Base URL of this
  abstract final String baseUrl;

  /// Headers of this
  abstract final HeaderBucket headers;

  /// Create a GET request
  /// ```dart
  /// final HttpClient client = HttpClient(baseUrl: '/');
  /// final response = await client.get('/foo').build();
  /// ```
  MethodAdapter get(String url);

  /// Create a POST request
  /// ```dart
  /// final HttpClient client = HttpClient(baseUrl: '/');
  /// final foo = await client.post('/foo/:id')
  ///   .payload({ 'name': 'John Doe' })
  ///   .build();
  /// ```
  MethodAdapter post(String url);

  /// Create a PUT request
  /// ```dart
  /// final HttpClient client = HttpClient(baseUrl: '/');
  /// final foo = await client.put('/foo/:id')
  ///  .payload({ 'name': 'John Doe' })
  ///  .build();
  ///  ```
  MethodAdapter put(String url);

  /// Create a PATCH request
  /// ```dart
  /// final HttpClient client = HttpClient(baseUrl: '/');
  /// final foo = await client.patch('/foo/:id')
  ///   .payload({ 'name': 'John Doe' })
  ///   .build();
  /// ```
  MethodAdapter patch(String url);

  /// Create a DELETE request
  /// ```dart
  /// final HttpClient client = HttpClient(baseUrl: '/');
  /// await client.delete('/foo/:id').build();
  /// ```
  MethodAdapter delete(String url);
}