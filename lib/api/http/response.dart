import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:mineral/api/http/header.dart';

abstract interface class Response<T> {
  abstract final int statusCode;
  abstract final Set<Header> headers;
  abstract final String bodyString;
  abstract final T body;
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

  ResponseImpl._(
      {required this.statusCode,
      required this.headers,
      required this.bodyString,
      required this.body});

  factory ResponseImpl.fromHttpResponse(http.Response response) => ResponseImpl._(
      statusCode: response.statusCode,
      headers: response.headers.entries.map((entry) => Header(entry.key, entry.value)).toSet(),
      bodyString: response.body,
      body: jsonDecode(response.body));
}
