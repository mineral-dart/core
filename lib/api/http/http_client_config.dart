import 'package:mineral/api/http/header.dart';

abstract interface class HttpClientConfig {
  String get baseUrl;

  Set<Header> get headers;
}

final class HttpClientConfigImpl implements HttpClientConfig {
  @override
  final String baseUrl;

  @override
  final Set<Header> headers;

  HttpClientConfigImpl({required this.baseUrl, Set<Header>? headers}) : headers = headers ?? {};
}
