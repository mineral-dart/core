import 'dart:convert';

import 'package:http/http.dart';
import 'package:mineral/core.dart';
import 'package:mineral/core/api.dart';
import 'package:mineral/exception.dart';
import 'package:mineral/framework.dart';
import 'package:mineral/src/api/managers/cache_manager.dart';
import 'package:mineral/src/api/messages/dm_message.dart';
import 'package:mineral/src/api/messages/partial_message.dart';
import 'package:mineral_cli/mineral_cli.dart';
import 'package:mineral_ioc/ioc.dart';

class MessageManager<T extends PartialMessage> extends CacheManager<T>  {
  final Snowflake? _guildId;
  final Snowflake _channelId;

  MessageManager(this._guildId, this._channelId);

  /// ### Bulk delete [Message] in channel ([PartialTextChannel], [DmChannel])
  ///
  /// Example :
  /// ```dart
  /// final TextChannel channel = await guild.channels.resolve('240561194958716924');
  /// await channel.bulkDelete.amount(100);
  /// await channel.bulkDelete.ids(["1077565703416193125", "1077383535477927977"]);
  /// ```
  BulkDeleteBuilder get bulkDelete => BulkDeleteBuilder(this);

  @Deprecated('Use `sync` method instead')
  Future<Map<Snowflake, T>> fetch () async {
    return sync();
  }

  Future<Map<Snowflake, T>> sync () async {
    Response response = await ioc.use<DiscordApiHttpService>()
      .get(url: "/channels/$_channelId/messages")
      .build();

    dynamic payload = jsonDecode(response.body);
    cache.clear();

    for (final element in payload) {
      if (_guildId != null) {
        final Guild guild = ioc.use<MineralClient>().guilds.cache.getOrFail(_guildId);
        Message message = Message.from(
          channel: guild.channels.cache.getOrFail(_channelId),
          payload: element
        );

        cache.putIfAbsent(message.id, () => message as T);
      } else {
        // @Todo add DM case
      }
    }

    return cache;
  }

  Future<T> resolve (Snowflake id) async {
    if(cache.containsKey(id)) {
      return cache.getOrFail(id);
    }

    final Response response = await ioc.use<DiscordApiHttpService>()
        .get(url: '/channels/$_channelId/messages/$id')
        .build();

    if(response.statusCode == 200) {
      dynamic payload = jsonDecode(response.body);

      if (_guildId != null) {
        final Guild guild = ioc.use<MineralClient>().guilds.cache.getOrFail(_guildId);
        Message message = Message.from(
            channel: guild.channels.cache.getOrFail(_channelId),
            payload: payload
        );

        cache.putIfAbsent(message.id, () => message as T);
        return message as T;
      } else {
        DmMessage message = DmMessage.from(
            channel: ioc.use<MineralClient>().dmChannels.cache.getOrFail(_channelId),
            payload: payload
        );

        cache.putIfAbsent(message.id, () => message as T);
        return message as T;
      }
    }

    throw ApiException('Unable to fetch message with id #$id');
  }
}

class BulkDeleteBuilder<T extends PartialMessage> {
  static const int maxMessages = 200;
  static const int minMessages = 2;

  final MessageManager<T> _manager;

  BulkDeleteBuilder(this._manager);

  /// ### Delete a specified [amount] of [Message]
  /// Amount **must be** between 2 and 200.
  ///
  /// Example :
  /// ```dart
  /// final TextChannel channel = await guild.channels.resolve('240561194958716924');
  /// await channel.bulkDelete.amount(100, reason: 'Too many messages in this channel');
  ///
  Future<void> amount(int amount, {String? reason}) async {
    if (amount >= maxMessages || amount <= minMessages) {
      return ioc.use<MineralCli>()
          .console.error('Provided too few or too many messages to delete. Must provide at least $minMessages and at most $maxMessages messages to delete. Action canceled');
    }

    if(_manager.cache.isEmpty || _manager.cache.length < amount) {
      await _manager.sync();
    }

    List<T> cache = _manager.cache.clone.values.toList();
    cache.sort((a, b) => a.createdAt.compareTo(b.createdAt));
    return messages(cache.reversed.take(amount).toList(), reason: reason);
  }

  /// ### Delete some specified [Message]
  ///
  /// Example :
  /// ```dart
  /// final TextChannel channel = await guild.channels.resolve('240561194958716924');
  /// await channel.bulkDelete.messages([channel.messages.cache.values.first, channel.messages.cache.values.last]);
  ///
  Future<void> messages(List<T> messages, {String? reason}) async {
    return ids(messages.map((e) => e.id).toList(), reason: reason);
  }

  /// ### Delete [Message] with their ids
  ///
  /// Example :
  /// ```dart
  /// final TextChannel channel = await guild.channels.resolve('240561194958716924');
  /// await channel.bulkDelete.ids(["1077565703416193125", "1077383535477927977"]);
  ///
  Future<void> ids(List<Snowflake> ids, {String? reason}) async {
    Response response = await ioc.use<DiscordApiHttpService>()
      .post(url: '/channels/${_manager._channelId}/messages/bulk-delete')
      .payload({ 'messages': ids })
      .auditLog(reason)
      .build();

    if (response.statusCode != 204) {
      throw ApiException("Unable to delete messages : ${response.statusCode} - ${response.body}");
    }

    for (final id in ids) {
      _manager.cache.remove(id);
    }
  }
}
