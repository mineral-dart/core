import 'package:mineral/services.dart';

abstract interface class HttpClientConfig {
  Uri get uri;

  Set<Header> get headers;

  Duration get requestTimeout;
}

final class HttpClientConfigImpl implements HttpClientConfig {
  @override
  final Uri uri;

  @override
  final Set<Header> headers;

  @override
  final Duration requestTimeout;

  HttpClientConfigImpl({
    required this.uri,
    Set<Header>? headers,
    this.requestTimeout = const Duration(seconds: 30),
  }) : headers = headers ?? {};
}
