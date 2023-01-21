import 'dart:convert';

import 'package:http/http.dart';
import 'package:mineral/src/internal/services/http_service/http_adapter_contract.dart';

class DestroyRequestBuilderAdapter extends HttpAdapterContract<DestroyRequestBuilderAdapter> {
  DestroyRequestBuilderAdapter(super._method, super._baseUrl, super._url, super._headers);

  DestroyRequestBuilderAdapter auditLog (String? value) {
    if (value != null) {
      httpHeaders.putIfAbsent('X-Audit-Log-Reason', () => value);
    }
    return this;
  }

  @override
  Future<Response> build () async {
    final request = Request(httpMethod.uid, Uri.parse('$httpBaseUrl$httpUrl'))
      ..body = jsonEncode(httpPayload)
      ..headers.addAll(httpHeaders);

    StreamedResponse response = await request.send();

    return Response.bytes(await response.stream.toBytes(), response.statusCode);
  }
}