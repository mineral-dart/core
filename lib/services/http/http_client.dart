import 'package:http/http.dart';
import 'package:mineral/services/http/builders/get_builder.dart';
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
  /// final response = client.get('/users').build();
  /// ```
  GetBuilder get(String url) {
    final request = Request('GET', Uri.parse('$baseUrl$url'))
      ..headers.addAll(headers.all);

    return GetBuilder(this, request);
  }
}