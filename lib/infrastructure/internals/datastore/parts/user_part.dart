import 'dart:async';

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
    final cachedRawUser = await _kernel.marshaller.cache.get(userId);
    if (cachedRawUser != null) {
      return _kernel.marshaller.serializers.user.serialize(cachedRawUser);
    }

    final response = await _kernel.dataStore.client.get('/users/$userId');
    final user = await _kernel.marshaller.serializers.user.serialize(response.body);

    await _kernel.marshaller.cache.put(userId, response.body);

    return user;
  }
}
