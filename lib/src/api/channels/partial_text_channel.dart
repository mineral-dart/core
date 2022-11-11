import 'dart:convert';

import 'package:http/http.dart';
import 'package:mineral/api.dart';
import 'package:mineral/builders.dart';
import 'package:mineral/core.dart';
import 'package:mineral/src/api/managers/message_manager.dart';
import 'package:mineral/src/internal/extensions/mineral_client.dart';

class PartialTextChannel extends GuildChannel {
  final MessageManager _messages;
  final Snowflake? _lastMessageId;

  PartialTextChannel(this._messages, this._lastMessageId, super.guildId, super.parentId, super.label, super.type, super.position, super.flags, super.permissions, super.id);

  /// Get [MessageManager]
  MessageManager get messages => _messages;

  /// Get last [Message] of this
  Message? get lastMessage => _messages.cache.get(_lastMessageId);

  /// Sends a message on this.
  /// ```dart
  /// final TextChannel channel = guild.channels.cache.getOrFail('240561194958716924');
  /// await channel.send(content: 'Hello world ! 🔥');
  /// ```
  Future<Message?> send ({ String? content, List<EmbedBuilder>? embeds, List<RowBuilder>? components, bool? tts }) async {
    MineralClient client = ioc.singleton(Service.client);

    Response response = await client.sendMessage(this,
      content: content,
      embeds: embeds,
      components: components
    );

    if (response.statusCode == 200) {
      Message message = Message.from(channel: this, payload: jsonDecode(response.body));
      messages.cache.putIfAbsent(message.id, () => message);

      return message;
    }

    return null;
  }
}
