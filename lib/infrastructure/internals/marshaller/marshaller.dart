import 'dart:async';

import 'package:mineral/api/common/channel.dart';
import 'package:mineral/api/common/snowflake.dart';
import 'package:mineral/api/private/user.dart';
import 'package:mineral/api/server/member.dart';
import 'package:mineral/api/server/server.dart';
import 'package:mineral/infrastructure/commons/helper.dart';
import 'package:mineral/infrastructure/internals/container/ioc_container.dart';
import 'package:mineral/infrastructure/internals/datastore/data_store.dart';
import 'package:mineral/infrastructure/internals/cache/cache_provider_contract.dart';
import 'package:mineral/infrastructure/internals/marshaller/serializer_bucket.dart';
import 'package:mineral/infrastructure/services/logger/logger.dart';

abstract interface class MarshallerContract {
  DataStoreContract get dataStore;

  LoggerContract get logger;

  SerializerBucket get serializers;

  CacheProviderContract get cache;

  Future<void> putUser(String id, User user);

  Future<({User? instance, Map<String, dynamic>? struct})> getUser(String id);

  Future<void> putChannel<T extends Channel>(String id, T channel);

  Future<({T? instance, Map<String, dynamic>? struct})> getChannel<T extends Channel>(String id);

  Future<void> putServer(String id, Server channel);

  Future<({Server? instance, Map<String, dynamic>? struct})> getServer<Server>(String id);

  Future<void> putMember(String id, Member member);

  Future<({Member? instance, Map<String, dynamic>? struct})> getMember(String id);
}

final class Marshaller implements MarshallerContract {
  @override
  DataStoreContract get dataStore => ioc.resolve<DataStoreContract>();

  @override
  final LoggerContract logger;

  @override
  late final SerializerBucket serializers;

  @override
  final CacheProviderContract cache;

  Marshaller(this.logger, this.cache) {
    serializers = SerializerBucketImpl(this);
    cache
      ..put('channels', {})
      ..put('users', {})
      ..put('servers', {})
      ..put('members', {});
  }

  Future<void> _put<T>(String id,
      {required String key,
      required T element,
      required FutureOr<Map<String, dynamic>> Function(T) fn}) async {
    final rawElement = fn(element);
    final cachedElements = await cache.getOrFail(key);

    cache.put(key, {...cachedElements, id: rawElement});
  }

  Future<({T? instance, Map<String, dynamic>? struct})> _get<T>(String id,
      {required String key, required FutureOr<T?> Function(Map<String, dynamic>) fn}) async {
    final cachedElements = await cache.getOrFail('members');

    return (
      struct: cachedElements[id] as Map<String, dynamic>?,
      instance: await Helper.createOrNullAsync(
          field: cachedElements[id], fn: () async => fn(cachedElements[id])),
    );
  }

  @override
  Future<void> putUser(String id, User user) async {
    _put<User>(id, key: 'users', element: user, fn: serializers.user.deserialize);
  }

  @override
  Future<({User? instance, Map<String, dynamic>? struct})> getUser(String id) async {
    return _get<User>(id, key: 'users', fn: serializers.user.serialize);
  }

  @override
  Future<void> putChannel<T extends Channel>(String id, T channel) async {
    _put<T>(id, key: 'channels', element: channel, fn: serializers.channels.deserialize);
  }

  @override
  Future<({T? instance, Map<String, dynamic>? struct})> getChannel<T extends Channel>(
      String id) async {
    return _get<T>(id,
        key: 'channels',
        fn: (Map<String, dynamic> channel) => serializers.channels.serialize(channel) as Future<T>);
  }

  @override
  Future<void> putServer(String id, Server channel) async {
    _put<Server>(id, key: 'channels', element: channel, fn: serializers.server.deserialize);
  }

  @override
  Future<({Server? instance, Map<String, dynamic>? struct})> getServer<Server>(String id) async {
    return _get<Server>(id,
        key: 'channels',
        fn: (Map<String, dynamic> channel) async =>
            serializers.server.serialize(channel) as Future<Server>);
  }

  @override
  Future<void> putMember(String id, Member member) async {
    _put<Member>(id, key: 'members', element: member, fn: serializers.member.deserialize);
  }

  @override
  Future<({Member? instance, Map<String, dynamic>? struct})> getMember(String id) async {
    return _get<Member>(id, key: 'members', fn: serializers.member.serialize);
  }
}
