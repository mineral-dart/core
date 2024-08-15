import 'dart:async';
import 'dart:io';

import 'package:mineral/api/common/snowflake.dart';
import 'package:mineral/api/private/user.dart';
import 'package:mineral/infrastructure/internals/datastore/data_store_part.dart';
import 'package:mineral/infrastructure/kernel/kernel.dart';
import 'package:mineral/infrastructure/services/http/http_client_status.dart';

final class UserPart implements DataStorePart {
  final KernelContract _kernel;

  HttpClientStatus get status => _kernel.dataStore.client.status;

  UserPart(this._kernel);

  Future<User> getUser(Snowflake userId) async {
    final cachedRawUser = await _kernel.marshaller.cache.get(userId.value);
    if (cachedRawUser != null) {
      return _kernel.marshaller.serializers.user.serializeCache(cachedRawUser);
    }

    final response = await _kernel.dataStore.client.get('/users/$userId');
    final user = await switch (response.statusCode) {
      int() when status.isSuccess(response.statusCode) =>
        _kernel.marshaller.serializers.user.serializeRemote(response.body),
      int() when status.isError(response.statusCode) => throw HttpException(response.body),
      _ => throw Exception('Unknown status code: ${response.statusCode}'),
    };

    final rawUser = await _kernel.marshaller.serializers.user.deserialize(user);
    await _kernel.marshaller.cache.put(userId.value, rawUser);

    return user;
  }
}
