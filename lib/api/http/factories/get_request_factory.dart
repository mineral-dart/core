import 'package:http/http.dart' as http;
import 'package:mineral/api/http/factories/request_factory.dart';
import 'package:mineral/api/http/http_method.dart';

final class GetRequestFactory implements RequestFactory {
  @override
  HttpMethod get method => HttpMethodImpl.get;

  @override
  Future<http.Response> create(http.Client client, Map<String, dynamic> payload) =>
      client.get(payload['uri'], headers: payload['headers']);
}
