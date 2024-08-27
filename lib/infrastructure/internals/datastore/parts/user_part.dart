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
    final cacheKey = _kernel.marshaller.cacheKey.user(userId);
    final cachedRawUser = await _kernel.marshaller.cache.get(cacheKey);
    if (cachedRawUser != null) {
      return _kernel.marshaller.serializers.user.serialize(cachedRawUser);
    }

    final response = await _kernel.dataStore.client.get('/users/$userId');
    if (status.isError(response.statusCode)) {
      throw HttpException(response.body);
    }

    final payload =
        await _kernel.marshaller.serializers.user.normalize(response.body);
    return _kernel.marshaller.serializers.user.serialize(payload);
  }
}
