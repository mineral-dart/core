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

  Future<User> getUser(Snowflake id) async {
    final cachedRawUser = await _kernel.marshaller.cache.get(id);

    if (cachedRawUser != null) {
      return _kernel.marshaller.serializers.user.serialize(cachedRawUser);
    }

    final [userResponse] = await Future.wait([
      _kernel.dataStore.client.get('/users/$id'),
    ]);

    final user = await _kernel.marshaller.serializers.user.serialize(userResponse.body);

    await Future.wait([
      _kernel.marshaller.cache.put(id, userResponse.body),
    ]);

    return user;
  }
}