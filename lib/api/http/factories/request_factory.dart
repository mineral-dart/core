import 'package:http/http.dart' as http;
import 'package:mineral/api/http/http_method.dart';

abstract interface class RequestFactory {
  HttpMethod get method;

  Future<http.Response> create(http.Client client, Map<String, dynamic> payload);
}
