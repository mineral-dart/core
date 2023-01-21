import 'dart:convert';

import 'package:http/http.dart';
import 'package:mineral/src/internal/services/http_service/http_method.dart';

abstract class HttpAdapterContract<T> {
  final HttpMethod httpMethod;
  final String httpBaseUrl;
  final String httpUrl;
  final List<MultipartFile> httpFiles = [];
  dynamic httpPayload;
  final Map<String, String> httpHeaders;

  HttpAdapterContract(this.httpMethod, this.httpBaseUrl, this.httpUrl, this.httpHeaders);

  T headers (Map<String, String> headers) {
    httpHeaders.addAll(headers);
    return _apply(this);
  }

  Future<Response> build () async {
    final Map<String, String> fields = {};
    StreamedResponse response;

    if (httpFiles.isNotEmpty) {
      final request = MultipartRequest(httpMethod.uid, Uri.parse('$httpBaseUrl$httpUrl'))
        ..files.addAll(httpFiles)
        ..fields.addAll(fields)
        ..headers.addAll(httpHeaders);

      response = await request.send();
    } else {
      final request = Request(httpMethod.uid, Uri.parse('$httpBaseUrl$httpUrl'))
        ..body = jsonEncode(httpPayload)
        ..headers.addAll(httpHeaders);

      response = await request.send();
    }

    return Response.bytes(await response.stream.toBytes(), response.statusCode);
  }

  T _apply (dynamic value) => value as T;
}