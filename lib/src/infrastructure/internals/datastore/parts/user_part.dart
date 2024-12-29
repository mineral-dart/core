import 'dart:async';
import 'dart:io';

import 'package:mineral/contracts.dart';
import 'package:mineral/services.dart';
import 'package:mineral/src/api/common/snowflake.dart';
import 'package:mineral/src/api/private/user.dart';
import 'package:mineral/src/domains/services/container/ioc_container.dart';

final class UserPart implements UserPartContract {
  MarshallerContract get _marshaller => ioc.resolve<MarshallerContract>();

  DataStoreContract get _dataStore => ioc.resolve<DataStoreContract>();

  HttpClientStatus get status => _dataStore.client.status;

  @override
  Future<User?> get(String id, bool force) async {
    final completer = Completer<User>();
    final String key = _marshaller.cacheKey.user(id);

    final cachedUser = await _marshaller.cache.get(key);
    if (!force && cachedUser != null) {
      final user = await _marshaller.serializers.user.serialize(cachedUser);
      completer.complete(user);

      return completer.future;
    }

    final response = await _dataStore.client.get('/users/$id');
    final rawUser = switch (response.statusCode) {
      int() when status.isSuccess(response.statusCode) =>
      await _marshaller.serializers.user.normalize(response.body),
      int() when status.isRateLimit(response.statusCode) =>
      throw HttpException(response.bodyString),
      int() when status.isError(response.statusCode) => throw HttpException(response.bodyString),
      _ => throw Exception('Unknown status code: ${response.statusCode} ${response.bodyString}')
    };

    completer.complete(await _marshaller.serializers.user.serialize(rawUser));
    return completer.future;
  }
}
