import 'dart:convert';

import 'package:http/http.dart';
import 'package:mineral/src/internal/services/http_service/http_adapter_contract.dart';

class PostDiscordRequestBuilderAdapter extends HttpAdapterContract<PostDiscordRequestBuilderAdapter> {
  final dynamic Function(Response response) _responseWrapper;

  PostDiscordRequestBuilderAdapter(super._method, super._baseUrl, super._url, super._headers, this._responseWrapper);

  PostDiscordRequestBuilderAdapter payload (dynamic fields) {
    httpPayload = fields;
    return this;
  }

  PostDiscordRequestBuilderAdapter files (List<MultipartFile> files) {
    httpFiles.addAll(files);
    return this;
  }

  PostDiscordRequestBuilderAdapter auditLog (String? value) {
    if (value != null) {
      httpHeaders.putIfAbsent('X-Audit-Log-Reason', () => value);
    }
    return this;
  }

  @override
  Future<Response> build () async {
    final Map<String, String> fields = {};
    StreamedResponse response;

    if (httpFiles.isNotEmpty) {
      fields.putIfAbsent('payload_json', () => jsonEncode(httpPayload));

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

    return _responseWrapper(Response.bytes(await response.stream.toBytes(), response.statusCode));
  }
}