import 'dart:convert';

import 'package:http/http.dart';
import 'package:mineral/services/http/contracts/http_response.dart';

class HttpPayload implements HttpResponse {
  final String url;
  final Map<String, String> headers;
  final int statusCode;
  final String bodyString;
  final dynamic body;

  HttpPayload._({
    required this.url,
    required this.headers,
    required this.statusCode,
    required this.bodyString,
    required this.body,
  });

  factory HttpPayload.fromHttpResponse(Response response) {
    return HttpPayload._(
      url: response.request!.url.toString(),
      headers: response.headers,
      statusCode: response.statusCode,
      bodyString: response.body,
      body: jsonDecode(response.body),
    );
  }
}