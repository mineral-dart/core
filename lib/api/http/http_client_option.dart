import 'package:mineral/api/http/header.dart';

abstract interface class HttpClientOption {
  abstract final Uri baseUrl;
  abstract final Set<Header> headers;
}

final class HttpClientOptionImpl implements HttpClientOption {
  @override
  final Uri baseUrl;

  @override
  final Set<Header> headers;

  HttpClientOptionImpl({required this.baseUrl, this.headers = const {}});
}
