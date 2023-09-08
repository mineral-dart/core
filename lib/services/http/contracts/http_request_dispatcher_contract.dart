import 'package:http/http.dart';
import 'package:mineral/internal/either.dart';

abstract interface class HttpRequestDispatcherContract {
  Future<EitherContract> process (BaseRequest request);
}