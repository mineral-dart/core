import 'dart:convert';

import 'package:http/http.dart';

final class HttpResponse {
  /// Status code of this
  final int statusCode;

  /// Headers of this
  final Map<String, String> headers;

  /// Payload of this
  final dynamic payload;

  /// Reason phrase of this
  final String? reasonPhrase;

  HttpResponse._({
    required this.statusCode,
    required this.headers,
    required this.payload,
    required this.reasonPhrase,
  });

  /// Create a [HttpResponse] from a [Response]
  factory HttpResponse.fromHttpResponse(Response response) {
    return HttpResponse._(
      statusCode: response.statusCode,
      headers: response.headers,
      payload: jsonDecode(response.body),
      reasonPhrase: response.reasonPhrase,
    );
  }
}