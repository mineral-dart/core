import 'package:http/http.dart' as http;
import 'package:mineral/api/http/factories/delete_request_factory.dart';
import 'package:mineral/api/http/factories/get_request_factory.dart';
import 'package:mineral/api/http/factories/patch_request_factory.dart';
import 'package:mineral/api/http/factories/post_request_factory.dart';
import 'package:mineral/api/http/factories/put_request_factory.dart';
import 'package:mineral/api/http/factories/request_factory.dart';
import 'package:mineral/api/http/header.dart';
import 'package:mineral/api/http/http_client_option.dart';
import 'package:mineral/api/http/http_method.dart';
import 'package:mineral/api/http/response.dart';

final class RequestProcessor {
  final Set<RequestFactory> factories = {
    GetRequestFactory(),
    PostRequestFactory(),
    PutRequestFactory(),
    PatchRequestFactory(),
    DeleteRequestFactory(),
  };

  Future<Response> process(http.Client client, HttpMethod method, HttpClientOption option, Uri uri,
      Set<Header> headers, Object? payload) async {
    final factory = factories.firstWhere((element) => element.method.name == method.name);

    final response = await factory.create(
        client, {'uri': uri, 'headers': serializeHeaders(option, headers), 'body': payload});

    return ResponseImpl.fromStreamedResponse(response);
  }

  Map<String, String> serializeHeaders(HttpClientOption option, Set<Header> headers) {
    return {
      ...option.headers
          .fold({}, (previousValue, element) => {...previousValue, element.key: element.value}),
      ...headers
          .fold({}, (previousValue, element) => {...previousValue, element.key: element.value}),
    };
  }
}
