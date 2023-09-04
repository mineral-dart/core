import 'dart:convert';

import 'package:http/http.dart';
import 'package:mineral/src/internal/services/http_service/http_adapter_contract.dart';

class PostRequestBuilderAdapter extends HttpAdapterContract<PostRequestBuilderAdapter> {
  PostRequestBuilderAdapter(super._method, super._baseUrl, super._url, super._headers);

  PostRequestBuilderAdapter payload (dynamic fields) {
    httpPayload = fields;
    return this;
  }

  PostRequestBuilderAdapter files (List<MultipartFile> files) {
    httpFiles.addAll(files);
    return this;
  }

  @override
  Future<Response> build () async {
    final Map<String, String> fields = {};
    StreamedResponse response;

    if (httpFiles.isNotEmpty) {
      for (final field in httpPayload.entries) {
        fields.putIfAbsent(field.key, () => jsonEncode(field.value));
      }

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
}