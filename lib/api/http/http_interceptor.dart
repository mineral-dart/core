import 'package:http/http.dart' as http;
import 'package:mineral/api/http/response.dart';

typedef RequestInterceptor = Future<http.Request> Function(http.Request);
typedef ResponseInterceptor = Future<Response> Function(Response);

abstract interface class HttpInterceptor {
  List<RequestInterceptor> get request;

  List<ResponseInterceptor> get response;
}

final class HttpInterceptorImpl implements HttpInterceptor {
  @override
  final List<RequestInterceptor> request = [];

  @override
  final List<ResponseInterceptor> response = [];
}
