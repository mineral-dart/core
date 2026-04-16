import 'package:mineral/api.dart';
import 'package:mineral/contracts.dart';
import 'package:mineral/services.dart';
import 'package:mineral/src/domains/container/ioc_container.dart';
import 'package:mineral/src/infrastructure/internals/http/discord_header.dart';
import 'package:mineral/src/infrastructure/io/exceptions/serialization_exception.dart';

final class ChannelPart implements ChannelPartContract {
  MarshallerContract get _marshaller => ioc.resolve<MarshallerContract>();

  DataStoreContract get _dataStore => ioc.resolve<DataStoreContract>();

  HttpClientStatus get status => _dataStore.client.status;

  @override
  Future<Map<Snowflake, T>> fetch<T extends Channel>(
      Object serverId, bool force) async {
    final req = Request.json(endpoint: '/guilds/$serverId/channels');
    final result = await _dataStore.requestBucket
        .query<List<Map<String, dynamic>>>(req)
        .run(_dataStore.client.get);

    final channels = await result.map((element) async {
      final raw = await _marshaller.serializers.channels.normalize(element);
      return _marshaller.serializers.channels.serialize(raw);
    }).wait;

    return channels.asMap().map((_, value) {
      if (value is! T)
        throw SerializationException(
            'Expected $T but got ${value.runtimeType}');
      return MapEntry(value.id, value);
    });
  }

  @override
  Future<T?> get<T extends Channel>(Object id, bool force) async {
    final String key = _marshaller.cacheKey.channel(id);
    final cachedChannel = await _marshaller.cache?.get(key);
    if (!force && cachedChannel != null) {
      final serialized =
          await _marshaller.serializers.channels.serialize(cachedChannel);
      if (serialized is! T)
        throw SerializationException(
            'Expected $T but got ${serialized.runtimeType}');

      return serialized;
    }

    final req = Request.json(endpoint: '/channels/$id');
    final result = await _dataStore.requestBucket
        .query<Map<String, dynamic>>(req)
        .run(_dataStore.client.get);

    final raw = await _marshaller.serializers.channels.normalize(result);
    final serialized = await _marshaller.serializers.channels.serialize(raw);
    if (serialized is! T)
      throw SerializationException(
          'Expected $T but got ${serialized.runtimeType}');

    return serialized;
  }

  @override
  Future<T> create<T extends Channel>(
      Object? serverId, ChannelBuilderContract builder,
      {String? reason}) async {
    final req = Request.json(
        endpoint: '/guilds/$serverId/channels',
        body: builder.build(),
        headers: {DiscordHeader.auditLogReason(reason)});

    final result = await _dataStore.requestBucket
        .query<Map<String, dynamic>>(req)
        .run(_dataStore.client.post);

    final raw = await _marshaller.serializers.channels.normalize(result);
    final serialized = await _marshaller.serializers.channels.serialize({
      ...raw,
      'guild_id': serverId,
    });
    if (serialized is! T)
      throw SerializationException(
          'Expected $T but got ${serialized.runtimeType}');

    return serialized;
  }

  @override
  Future<PrivateChannel> createPrivateChannel(
      Object id, Object recipientId) async {
    final req = Request.json(
        endpoint: '/users/@me/channels', body: {'recipient_id': recipientId});

    final result = await _dataStore.requestBucket
        .query<Map<String, dynamic>>(req)
        .run(_dataStore.client.post);

    final raw = await _marshaller.serializers.channels.normalize(result);
    final channel = await _marshaller.serializers.channels.serialize(raw);

    return channel as PrivateChannel;
  }

  @override
  Future<T?> update<T extends Channel>(
      Object id, ChannelBuilderContract builder,
      {Object? serverId, String? reason}) async {
    final req = Request.json(
        endpoint: '/channels/$id',
        body: builder.build(),
        headers: {DiscordHeader.auditLogReason(reason)});

    final result = await _dataStore.requestBucket
        .query<Map<String, dynamic>>(req)
        .run(_dataStore.client.patch);

    final raw = await _marshaller.serializers.channels.normalize(result);
    final serialized = await _marshaller.serializers.channels.serialize({
      ...raw,
      'guild_id': serverId,
    });
    if (serialized is! T)
      throw SerializationException(
          'Expected $T but got ${serialized.runtimeType}');

    return serialized;
  }

  @override
  Future<void> delete(Object id, String? reason) async {
    final req = Request.json(
        endpoint: '/channels/$id',
        headers: {DiscordHeader.auditLogReason(reason)});

    await _dataStore.requestBucket
        .query<Map<String, dynamic>>(req)
        .run(_dataStore.client.delete);
  }
}
