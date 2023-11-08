import 'package:mineral/api/http/header.dart';

abstract interface class HttpClientOption {
  String get baseUrl;
  Set<Header> get headers;
}

final class HttpClientOptionImpl implements HttpClientOption {
  @override
  final String baseUrl;

  @override
  final Set<Header> headers;

  HttpClientOptionImpl({required this.baseUrl, this.headers = const {}});
}
