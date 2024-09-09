import 'package:mineral/src/infrastructure/services/http/header.dart';

abstract interface class Request {
  String get method;

  Uri get url;

  Set<Header> get headers;

  String get bodyString;

  Object? get body;
}

final class RequestImpl implements Request {
  @override
  String method;

  @override
  Object? body;

  @override
  String bodyString;

  @override
  Set<Header> headers;

  @override
  Uri url;

  RequestImpl(
      {required this.method,
      required this.url,
      required this.headers,
      required this.bodyString,
      required this.body});
}
