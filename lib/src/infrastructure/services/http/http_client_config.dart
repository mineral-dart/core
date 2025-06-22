import 'package:mineral/services.dart';

abstract interface class HttpClientConfig {
  Uri get uri;

  Set<Header> get headers;
}

final class HttpClientConfigImpl implements HttpClientConfig {
  @override
  final Uri uri;

  @override
  final Set<Header> headers;

  HttpClientConfigImpl({required this.uri, Set<Header>? headers})
      : headers = headers ?? {};
}
