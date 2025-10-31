import 'dart:convert';
import 'dart:io';

import 'package:mineral/contracts.dart';
import 'package:mineral/services.dart';

final class RequestExecutor {
  final HttpClientContract client;
  final LoggerContract logger;

  RequestExecutor({
    required this.client,
    required this.logger,
  });

  Future<T> send<T>(RequestContract request) async {
    final response = await client.send(request);

    return switch (response.statusCode) {
      _ when [404, 401, 500].contains(response.statusCode) =>
        throwError(response),
      _ => response.body
    } as T;
  }

  void throwError(Response response, {String? message}) {
    final data = {
      'method': response.method,
      'statusCode': response.statusCode,
      'reason': response.reasonPhrase,
      'url': response.uri.toString()
    };

    throw HttpException(jsonEncode(data));
  }
}
