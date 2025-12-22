import 'dart:async';
import 'dart:io';

import 'package:mineral/container.dart';
import 'package:mineral/contracts.dart';
import 'package:mineral/services.dart';

typedef RequestAction<T> = Future<Response<T>> Function(
    RequestContract request);

enum QueueableRequestStatus { init, success, error, rateLimit, pending }

final class QueueableRequest<T> {
  LoggerContract get _logger => ioc.resolve<LoggerContract>();

  DataStoreContract get _dataStore => ioc.resolve<DataStoreContract>();

  HttpClientStatus get _httpStatus => _dataStore.client.status;

  final RequestBucket bucket;
  final Completer<T> completer;
  final RequestContract query;
  final RequestAction request;

  DateTime? retryAt;
  QueueableRequestStatus status = QueueableRequestStatus.init;

  final Exception Function(Response)? _onError;
  final void Function(T)? _onSuccess;
  final void Function(Duration)? _onRateLimit;

  QueueableRequest(this.bucket, this.query, this.request, this.completer,
      this._onError, this._onSuccess, this._onRateLimit);

  Future<void> execute() async {
    status = QueueableRequestStatus.pending;
    final response = await request(query);

    if (response.statusCode case final int code
        when _httpStatus.isSuccess(code)) {
      status = QueueableRequestStatus.success;

      bucket.queue.remove(this);
      _onSuccess?.call(response.body as T);
      completer.complete(response.body as T);
    }

    if (response.statusCode case final int code
        when _httpStatus.isRateLimit(code)) {
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

    if (response.statusCode case final int code
        when _httpStatus.isError(code)) {
      status = QueueableRequestStatus.error;

      bucket.queue.remove(this);
      _onError?.call(response);
      completer.completeError(
          _onError?.call(response) ?? HttpException(response.bodyString));
    }
  }
}

final class RequestBucket {
  bool hasGlobalLocked = false;
  List<QueueableRequest> queue = [];

  RequestHandler<T> query<T>(RequestContract request) =>
      RequestHandler<T>(this, request);
}

final class RequestHandler<T> {
  final RequestBucket _bucket;
  final RequestContract _request;

  RequestHandler(this._bucket, this._request);

  Future<T> run(Future<Response<T>> Function(RequestContract request) action,
      {void Function(T)? onSuccess,
      Exception Function(Response)? onError,
      void Function(Duration)? onRateLimit}) async {
    final completer = Completer<T>();
    final request = QueueableRequest<T>(
        _bucket, _request, action, completer, onError, onSuccess, onRateLimit);
    _bucket.queue.add(request);

    await request.execute();
    return completer.future;
  }
}
