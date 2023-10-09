import 'package:http/http.dart';
import 'package:mineral/services/http/contracts/http_response.dart';

abstract interface class HttpRequestDispatcherContract {
  Future<HttpResponse> process (BaseRequest request);
}