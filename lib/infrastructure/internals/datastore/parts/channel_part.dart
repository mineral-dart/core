import 'dart:async';
import 'dart:io';

import 'package:mineral/api.dart';
import 'package:mineral/api/common/channel.dart';
import 'package:mineral/api/common/components/message_component.dart';
import 'package:mineral/api/common/embed/message_embed.dart';
import 'package:mineral/api/common/message.dart';
import 'package:mineral/api/common/polls/poll.dart';
import 'package:mineral/api/common/snowflake.dart';
import 'package:mineral/api/private/channels/private_channel.dart';
import 'package:mineral/api/server/channels/server_channel.dart';
import 'package:mineral/api/server/channels/thread_channel.dart';
import 'package:mineral/infrastructure/commons/helper.dart';
import 'package:mineral/infrastructure/internals/datastore/data_store_part.dart';
import 'package:mineral/infrastructure/internals/http/discord_header.dart';
import 'package:mineral/infrastructure/internals/marshaller/types/serializer.dart';
import 'package:mineral/infrastructure/kernel/kernel.dart';
import 'package:mineral/infrastructure/services/http/http_client_status.dart';
import 'package:mineral/infrastructure/services/http/http_request_option.dart';
import 'package:mineral/infrastructure/services/http/response.dart';

final class ChannelPart implements DataStorePart {
  final KernelContract _kernel;

  HttpClientStatus get status => _kernel.dataStore.client.status;

  ChannelPart(this._kernel);

  Future<T?> getChannel<T extends Channel>(Snowflake id) async {
    final String key = _kernel.marshaller.cacheKey.channel(id);

    final cachedChannel = await _kernel.marshaller.cache.get(key);
    if (cachedChannel != null) {
      return _kernel.marshaller.serializers.channels.serialize(cachedChannel) as Future<T?>;
    }

    final threadKey = _kernel.marshaller.cacheKey.thread(id);
    final cachedThread = await _kernel.marshaller.cache.get(threadKey);

    if (cachedThread != null) {
      return _kernel.marshaller.serializers.thread.serialize(cachedThread) as Future<T?>;
    }

    final response = await _kernel.dataStore.client.get('/channels/$id');
    final T? channel = await serializeChannelResponse<T>(response);

    return channel;
  }

  Future<ThreadChannel?> getThread(Snowflake id) async {
    final String key = _kernel.marshaller.cacheKey.thread(id);

    final cachedThread = await _kernel.marshaller.cache.get(key);
    if (cachedThread != null) {
      return _kernel.marshaller.serializers.thread.serialize(cachedThread) as ThreadChannel;
    }

    final response = await _kernel.dataStore.client.get('/channels/$id');
    final rawThread = await _kernel.marshaller.serializers.thread.normalize(response.body);
    final thread = await _kernel.marshaller.serializers.thread.serialize(rawThread);
    final parentChannel = await getChannel(Snowflake(thread.channelId)) as ServerTextChannel;

    thread
      ..server = await _kernel.dataStore.server.getServer(rawThread['guild_id'])
      ..parentChannel = parentChannel;

    return thread;
  }

  Future<T?> createServerChannel<T extends Channel>({required Snowflake id, required Map<String, dynamic> payload, required String? reason}) async {
    final response = await _kernel.dataStore.client
        .post('/guilds/$id/channels', body: payload, option: HttpRequestOptionImpl(headers: {DiscordHeader.auditLogReason(reason)}));

    final Channel? channel = await serializeChannelResponse(response);

    return channel as T?;
  }

  Future<PrivateChannel?> createPrivateChannel({required Snowflake id, required Snowflake recipientId}) async {
    final response = await _kernel.dataStore.client.post('/users/@me/channels', body: {'recipient_id': recipientId});

    final Channel? channel = await serializeChannelResponse(response);

    return channel as PrivateChannel?;
  }

  Future<T?> updateChannel<T extends Channel>({required Snowflake id, required Map<String, dynamic> payload, required String? reason}) async {
    final response =
        await _kernel.dataStore.client.patch('/channels/$id', body: payload, option: HttpRequestOptionImpl(headers: {DiscordHeader.auditLogReason(reason)}));

    final Channel? channel = await serializeChannelResponse(response);

    return channel as T?;
  }

  Future<void> deleteChannel(Snowflake id, String? reason) async {
    final response = await _kernel.dataStore.client.delete('/channels/$id', option: HttpRequestOptionImpl(headers: {DiscordHeader.auditLogReason(reason)}));

    return switch (response.statusCode) {
      int() when status.isSuccess(response.statusCode) => _kernel.marshaller.cache.remove(id.value),
      int() when status.isError(response.statusCode) => throw HttpException(response.bodyString),
      _ => throw Exception('Unknown status code: ${response.statusCode}'),
    };
  }

  Future<T> createMessage<T extends Message>(
      Snowflake? guildId, Snowflake channelId, String? content, List<MessageEmbed>? embeds, Poll? poll, List<MessageComponent>? components) async {
    final response = await _kernel.dataStore.client.post('/channels/$channelId/messages', body: {
      'content': content,
      'embeds': await Helper.createOrNullAsync(field: embeds, fn: () async => embeds?.map(_kernel.marshaller.serializers.embed.deserialize).toList()),
      'poll': await Helper.createOrNullAsync(field: poll, fn: () async => _kernel.marshaller.serializers.poll.deserialize(poll!)),
      'components': components?.map((e) => e.toJson()).toList(),
    });

    final channel = await _kernel.dataStore.channel.getChannel(channelId);
    final serializer = switch (channel) {
      ServerChannel() => _kernel.marshaller.serializers.serverMessage,
      PrivateChannel() => _kernel.marshaller.serializers.privateMessage,
      _ => throw Exception('Unknown channel type: $channel'),
    } as SerializerContract<T>;

    final payload = await serializer.normalize({
      ...response.body,
      'server_id': guildId,
    });

    return serializer.serialize(payload);
  }

  Future<T?> serializeChannelResponse<T extends Channel>(Response response) async {
    return switch (response.statusCode) {
      int() when status.isSuccess(response.statusCode) => () async {
          final payload = await _kernel.marshaller.serializers.channels.normalize(response.body);
          final channel = await _kernel.marshaller.serializers.channels.serialize(payload);

          if (channel is ServerChannel) {
            await _updateCacheFromChannelServer(channel.id, channel, payload);
          }

          return channel as T?;
        },
      int() when status.isError(response.statusCode) => throw HttpException(response.bodyString),
      _ => throw Exception('Unknown status code: ${response.statusCode} ${response.bodyString}'),
    } as Future<T?>;
  }

  Future<void> _updateCacheFromChannelServer(Snowflake id, ServerChannel channel, Map<String, dynamic> rawChannel) async {
    final server = await _kernel.dataStore.server.getServer(rawChannel['guild_id']);
    server.channels.list[channel.id] = channel;

    final rawServer = await _kernel.marshaller.serializers.server.deserialize(server);

    await _kernel.marshaller.cache.putMany({
      _kernel.marshaller.cacheKey.server(server.id): rawServer,
    });
  }
}
