import 'dart:async';
import 'dart:io';

import 'package:mineral/src/infrastructure/io/exceptions/http_status_exception.dart';
import 'package:mineral/src/infrastructure/services/http/http_client_status.dart';
import 'package:mineral/src/infrastructure/services/http/response.dart';

mixin ResponseHandler {
  HttpClientStatus get status;

  Future<T> handleResponse<T>(
    Response<dynamic> response,
    FutureOr<T> Function(dynamic body) onSuccess,
  ) async {
    return switch (response.statusCode) {
      int() when status.isSuccess(response.statusCode) => onSuccess(response.body),
      int() when status.isRateLimit(response.statusCode) =>
        throw HttpException(response.bodyString),
      int() when status.isError(response.statusCode) =>
        throw HttpException(response.bodyString),
      _ => throw HttpStatusException(response.statusCode, response.bodyString),
    };
  }
}
