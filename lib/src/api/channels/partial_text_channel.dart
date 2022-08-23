import 'package:mineral/api.dart';
import 'package:mineral/src/api/managers/message_manager.dart';

class PartialTextChannel extends GuildChannel {
  final MessageManager _messages;
  final Snowflake? _lastMessageId;

  PartialTextChannel(this._messages, this._lastMessageId, super.guildId, super.parentId, super.label, super.type, super.position, super.flags, super.permissions, super.id);

  /// Get [MessageManager]
  MessageManager get messages => _messages;

  /// Get last [Message] of this
  Message? get lastMessage => _messages.cache.get(_lastMessageId);
}
