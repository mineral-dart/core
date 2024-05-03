import 'dart:convert';
import 'dart:io';

import 'package:mineral/infrastructure/http/http_client.dart';
import 'package:mineral/infrastructure/http/response.dart';
import 'package:mineral/infrastructure/logger/logger.dart';
import 'package:mineral/domains/http/http_endpoint.dart';

abstract interface class RequestExecutorContract {
  HttpClientContract get client;

  Future<T> send<T>(HttpEndpoint endpoint, {List<dynamic>? values});
}

final class RequestExecutor implements RequestExecutorContract {
  @override
  final HttpClientContract client;

  final LoggerContract logger;

  RequestExecutor({required this.client, required this.logger});

  @override
  Future<T> send<T>(HttpEndpoint endpoint, {List<dynamic>? values}) async {
    final response = await client.send(endpoint.method, endpoint.url);

    return switch(response.statusCode) {
      _ when [404, 401, 500].contains(response.statusCode) => throwError(response),
      _ => response.body
    } as T;
  }

  void throwError (Response response, { String? message }) {
    final data = {
      'method': response.method,
      'statusCode': response.statusCode,
      'reason': response.reasonPhrase,
      'url': response.uri.toString()
    };

    throw HttpException(jsonEncode(data));
  }
}
