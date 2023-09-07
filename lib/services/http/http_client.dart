import 'package:mineral/services/http/header_bucket.dart';

/// HTTP Client used to make requests to a server
/// ```dart
/// final HttpClient client = HttpClient(baseUrl: '/');
/// ```
class HttpClient {
  /// Base URL of this
  final String baseUrl;

  /// Headers of this
  final HeaderBucket headers = HeaderBucket();

  HttpClient({ required this.baseUrl, Map<String, String> headers = const {} }) {
    this.headers.addAll(headers);
  }
}