import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:mineral/infrastructure/services/http/header.dart';

abstract interface class Response<T> {
  abstract final int statusCode;
  abstract final Set<Header> headers;
  abstract final String bodyString;
  abstract final T body;

  Uri get uri;

  String? get reasonPhrase;

  String get method;
}

final class ResponseImpl<T> implements Response<T> {
  @override
  final int statusCode;

  @override
  final Set<Header> headers;

  @override
  final String bodyString;

  @override
  final T body;

  @override
  final Uri uri;

  @override
  final String? reasonPhrase;

  @override
  final String method;

  ResponseImpl._(
      {required this.statusCode,
      required this.headers,
      required this.bodyString,
      required this.body,
      required this.uri,
      required this.reasonPhrase,
      required this.method});

  factory ResponseImpl.fromHttpResponse(http.Response response) {
    return ResponseImpl._(
        statusCode: response.statusCode,
        headers: response.headers.entries.map((entry) => Header(entry.key, entry.value)).toSet(),
        bodyString: response.body,
        body: response.body.isNotEmpty ? jsonDecode(response.body) : {},
        uri: response.request!.url,
        reasonPhrase: response.reasonPhrase,
        method: response.request!.method);
  }
}
