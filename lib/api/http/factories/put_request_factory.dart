import 'package:http/http.dart' as http;
import 'package:mineral/api/http/factories/request_factory.dart';
import 'package:mineral/api/http/http_method.dart';

final class PutRequestFactory implements RequestFactory {
  @override
  HttpMethod get method => HttpMethodImpl.put;

  @override
  Future<http.Response> create(http.Client client, Map<String, dynamic> payload) =>
      client.put(payload['uri'], headers: payload['headers'], body: payload['body']);
}
