import 'package:mineral/services/http/contracts/http_response.dart';

abstract class MethodAdapter {
  Future<HttpResponse> build ();
}