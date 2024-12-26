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
  Future<User> getUser(Snowflake userId) async {
    final cacheKey = _marshaller.cacheKey.user(userId.value);
    final cachedRawUser = await _marshaller.cache.get(cacheKey);
    if (cachedRawUser != null) {
      return _marshaller.serializers.user.serialize(cachedRawUser);
    }

    final response = await _dataStore.client.get('/users/$userId');
    if (status.isError(response.statusCode)) {
      throw HttpException(response.body);
    }

    final payload = await _marshaller.serializers.user.normalize(response.body);
    return _marshaller.serializers.user.serialize(payload);
  }
}
