import 'dart:convert';

import 'package:http/http.dart';

final class HttpResponse {
  final int statusCode;
  final Map<String, String> headers;
  final dynamic payload;
  final String? reasonPhrase;

  HttpResponse._({
    required this.statusCode,
    required this.headers,
    required this.payload,
    required this.reasonPhrase,
  });
  
  factory HttpResponse.fromHttpResponse(Response response) {
    return HttpResponse._(
      statusCode: response.statusCode,
      headers: response.headers,
      payload: jsonDecode(response.body),
      reasonPhrase: response.reasonPhrase,
    );
  }
}