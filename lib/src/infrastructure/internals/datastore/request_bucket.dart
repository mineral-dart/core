import 'dart:async';
import 'dart:io';

import 'package:mineral/container.dart';
import 'package:mineral/contracts.dart';
import 'package:mineral/services.dart';

typedef RequestAction = Future<Response> Function();

enum QueueableRequestStatus { init, success, error, rateLimit, pending }

final class QueueableRequest<T> {
  LoggerContract get _logger => ioc.resolve<LoggerContract>();

  DataStoreContract get _dataStore => ioc.resolve<DataStoreContract>();

  HttpClientStatus get _httpStatus => _dataStore.client.status;

  final RequestBucket bucket;
  final Completer<T> completer;
  final RequestAction request;

  DateTime? retryAt;
  QueueableRequestStatus status = QueueableRequestStatus.init;

  final T Function<T extends Exception>(Response)? _onError;
  final Function(T)? _onSuccess;
  final Function(Duration)? _onRateLimit;

  QueueableRequest(this.bucket, this.request, this.completer, this._onError, this._onSuccess, this._onRateLimit);

  Future<void> execute() async {
    status = QueueableRequestStatus.pending;
    final response = await request();

    if (response.statusCode case final int code when _httpStatus.isSuccess(code)) {
      status = QueueableRequestStatus.success;

      bucket.reactionQueue.remove(this);
      _onSuccess?.call(response.body as T);
      completer.complete(response.body as T);
    }

    if (response.statusCode case final int code when _httpStatus.isRateLimit(code)) {
      bucket.hasGlobalLocked = response.body['global'];

      final retryAfter = response.body['retry_after'];
      final seconds = double.parse(retryAfter.toString());
      final value = seconds.toInt() + 1;

      _logger.warn('Rate limit reached. Retrying in $value seconds');

      status = QueueableRequestStatus.rateLimit;
      retryAt = DateTime.now().add(Duration(seconds: value));

      _onRateLimit?.call(Duration(seconds: value));
      await Future.delayed(Duration(seconds: value), execute);
    }

    if (response.statusCode case final int code when _httpStatus.isError(code)) {
      status = QueueableRequestStatus.error;

      bucket.reactionQueue.remove(this);
      _onError?.call(response);
      completer.completeError(_onError?.call(response) ?? HttpException(response.bodyString));
    }
  }
}

final class RequestBucket {
  bool hasGlobalLocked = false;
  List<QueueableRequest> reactionQueue = [];

  Future<T> run<T>(RequestAction action,
      {Function(T)? onSuccess,
      T Function<T extends Exception>(Response)? onError,
      Function(Duration)? onRateLimit}) async {
    final completer = Completer<T>();
    final request = QueueableRequest<T>(this, action, completer, onError, onSuccess, onRateLimit);
    reactionQueue.add(request);

    await request.execute();
    return completer.future;
  }
}
