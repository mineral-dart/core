import 'dart:async';
import 'dart:io';

import 'package:mineral/container.dart';
import 'package:mineral/contracts.dart';
import 'package:mineral/services.dart';

typedef RequestAction<T> = Future<Response<T>> Function(
    RequestContract request);

enum QueueableRequestStatus { init, success, error, rateLimit, pending }

final class QueueableRequest<T> {
  static const int _maxRateLimitRetries = 5;

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
    for (var attempt = 0; attempt < _maxRateLimitRetries; attempt++) {
      status = QueueableRequestStatus.pending;
      final response = await request(query);

      if (_httpStatus.isSuccess(response.statusCode)) {
        status = QueueableRequestStatus.success;
        bucket.queue.remove(this);
        try {
          _onSuccess?.call(response.body as T);
          completer.complete(response.body as T);
        } on TypeError catch (e) {
          completer.completeError(HttpException(
            'Response body type mismatch: expected $T, '
            'got ${response.body.runtimeType}. $e',
          ));
        }
        return;
      }

      if (_httpStatus.isRateLimit(response.statusCode)) {
        bucket.hasGlobalLocked = response.body['global'] as bool? ?? false;

        final retryAfter = response.body['retry_after'];
        final seconds = double.tryParse(retryAfter.toString()) ?? 1.0;
        final delay = Duration(seconds: seconds.toInt() + 1);

        _logger.warn(
          'Rate limit reached (attempt ${attempt + 1}/$_maxRateLimitRetries). '
          'Retrying in ${delay.inSeconds}s',
        );

        status = QueueableRequestStatus.rateLimit;
        retryAt = DateTime.now().add(delay);

        _onRateLimit?.call(delay);
        await Future<void>.delayed(delay);
        continue;
      }

      if (_httpStatus.isError(response.statusCode)) {
        status = QueueableRequestStatus.error;
        bucket.queue.remove(this);
        final exception =
            _onError?.call(response) ?? HttpException(response.bodyString);
        completer.completeError(exception);
        return;
      }
    }

    // Rate limit retry cap reached
    status = QueueableRequestStatus.error;
    bucket.queue.remove(this);
    completer.completeError(
      HttpException('Rate limit retry cap ($_maxRateLimitRetries) reached'),
    );
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
