import 'package:mineral/api/http/http_method.dart';

abstract interface class Request {
  abstract final Uri uri;
  abstract final HttpMethod method;
}
