import 'package:mineral/services/http/contracts/http_response.dart';
import 'package:mineral/services/http/entities/http_error.dart';
import 'package:mineral/services/http/entities/http_payload.dart';

final class Either {
  static Future<T> future<T> ({ required Future<HttpResponse> future, void Function(HttpError)? onError, T Function(HttpPayload)? onSuccess }) async {
    try {
      final result = await future;

      if (result is HttpError && onError != null) {
        onError(result);
      }

      return onSuccess != null
        ? onSuccess(result as HttpPayload)
        : result as T;
    } catch (error) {
      rethrow;
    }
  }
}