import 'package:mineral/core.dart';
import 'package:mineral/core/api.dart';
import 'package:mineral/core/builders.dart';
import 'package:mineral/framework.dart';
import 'package:mineral/src/api/managers/message_reaction_manager.dart';
import 'package:mineral/src/api/messages/message_attachment.dart';
import 'package:mineral/src/api/messages/message_sticker_item.dart';
import 'package:mineral_ioc/ioc.dart';

class PartialMessage<T extends PartialChannel>  {
  final Snowflake _id;
  final String _content;
  final bool _tts;
  final List<EmbedBuilder> _embeds;
  final bool _allowMentions;
  final PartialMessage? _reference;
  final ComponentBuilder _components;
  final List<MessageStickerItem> _stickers;
  final dynamic _payload;
  final List<MessageAttachment> _attachments;
  final int? _flags;
  final bool _pinned;
  final Snowflake? _guildId;
  final Snowflake _channelId;
  final MessageReactionManager _reactions;
  final String _timestamp;
  final String? _editedTimestamp;

  PartialMessage(
    this._id,
    this._content,
    this._tts,
    this._embeds,
    this._allowMentions,
    this._reference,
    this._components,
    this._stickers,
    this._payload,
    this._attachments,
    this._flags,
    this._pinned,
    this._guildId,
    this._channelId,
    this._reactions,
    this._timestamp,
    this._editedTimestamp
  );

  /// Get id [Snowflake] of this
  Snowflake get id => _id;

  /// Get content [String] of this
  String get content => _content;

  /// Get if this is tts [bool]
  bool get tts => _tts;

  /// Get allow mentions [bool] of this
  bool get allowMentions => _allowMentions;

  /// Get reference [PartialMessage] of this
  PartialMessage? get reference => _reference;

  /// Get stickers [MessageStickerItem] of this
  List<MessageStickerItem> get stickers => _stickers;

  /// Get components [ComponentBuilder] of this
  ComponentBuilder get components => _components;

  /// Get embeds [EmbedBuilder] of this
  List<EmbedBuilder> get embeds => _embeds;

  /// Get attachments [MessageAttachment] of this
  List<MessageAttachment> get attachments => _attachments;

  /// Get flags [int] of this
  int? get flags => _flags;

  /// Get if this is pinned [bool]
  bool get isPinned => _pinned;

  /// Get channel of this [T]
  T get channel => _guildId != null
    ? ioc.use<MineralClient>().guilds.cache.getOrFail(_guildId).channels.cache.getOrFail(_channelId) as T
    : ioc.use<MineralClient>().dmChannels.cache.getOrFail(_channelId) as T;

  /// Get reactions [MessageReactionManager] of this
  MessageReactionManager get reactions => _reactions;

  /// Get created at [DateTime] of this
  DateTime get createdAt => DateTime.parse(_timestamp);

  /// Get edited at [DateTime] of this
  DateTime? get updatedAt =>  _editedTimestamp != null ? DateTime.parse(_editedTimestamp!) : null;

  dynamic get payload => _payload;

  /// Delete this
  /// ```dart
  /// await message.delete(reason: 'Lorem ipsum dolor sit amet');
  /// ```
  Future<void> delete ({ String? reason }) async {
    await ioc.use<DiscordApiHttpService>()
      .destroy(url: '/channels/$_channelId/messages/$id')
      .auditLog(reason)
      .build();
  }
}
