import 'dart:async';

import 'package:mineral/internal/reporter/result.dart';

final class Either {
  FutureOr<Result> future (Future<dynamic> future) {
    return future
      .catchError((dynamic error, StackTrace? stackTrace) => Failure(error, stackTrace: stackTrace))
      .then((dynamic value) => Success(value));
  }
}