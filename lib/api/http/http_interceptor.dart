import 'package:mineral/api/http/request.dart';
import 'package:mineral/api/http/response.dart';

typedef RequestInterceptor = Future<Request> Function(Request);
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
