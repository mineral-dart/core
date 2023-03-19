import 'package:http/http.dart';
import 'package:mineral/src/internal/services/http_service/http_adapter_contract.dart';

class GetDiscordRequestBuilderAdapter extends HttpAdapterContract<GetDiscordRequestBuilderAdapter> {
  final dynamic Function(Response response) _responseWrapper;

  GetDiscordRequestBuilderAdapter(super._method, super._baseUrl, super._url, super._headers, this._responseWrapper);

  @override
  Future<Response> build () async {
    final request = Request(httpMethod.uid, Uri.parse('$httpBaseUrl$httpUrl'))
      ..headers.addAll(httpHeaders);

    final response = await request.send();
    return _responseWrapper(Response.bytes(await response.stream.toBytes(), response.statusCode));
  }
}