import 'package:mineral/infrastructure/http/header.dart';

abstract interface class HttpRequestOption {
  Set<Header> get headers;

  Map<String, String> get queryParameters;
}

final class HttpRequestOptionImpl implements HttpRequestOption {
  @override
  final Set<Header> headers;

  @override
  final Map<String, String> queryParameters;

  HttpRequestOptionImpl({required this.headers, this.queryParameters = const {}});
}
