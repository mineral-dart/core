import 'package:mineral/services/http/header_bucket.dart';

class HttpClient {
  final String baseUrl;
  final HeaderBucket headers = HeaderBucket();

  HttpClient({ required this.baseUrl, Map<String, String> headers = const {} }) {
    this.headers.addAll(headers);
  }
}