import 'package:mineral/core.dart';
import 'package:mineral/core/api.dart';
import 'package:mineral/core/builders.dart';
import 'package:mineral/framework.dart';
import 'package:mineral/src/api/builders/component_builder.dart';
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
  final List<ComponentBuilder> _components;
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

  Snowflake get id => _id;

  String get content => _content;

  bool get tts => _tts;

  bool get allowMentions => _allowMentions;

  PartialMessage? get reference => _reference;

  List<MessageStickerItem> get stickers => _stickers;

  List<ComponentBuilder> get components => _components;

  List<EmbedBuilder> get embeds => _embeds;

  dynamic get payload => _payload;

  List<MessageAttachment> get attachments => _attachments;

  int? get flags => _flags;

  bool get isPinned => _pinned;

  dynamic get channel => _guildId != null
    ? ioc.use<MineralClient>().guilds.cache.getOrFail(_guildId).channels.cache.getOrFail(_channelId)
    : ioc.use<MineralClient>().dmChannels.cache.getOrFail(_channelId);

  MessageReactionManager get reactions => _reactions;

  DateTime get createdAt => DateTime.parse(_timestamp);
  DateTime? get updatedAt =>  _editedTimestamp != null ? DateTime.parse(_editedTimestamp!) : null;

  Future<void> delete () async {
    await ioc.use<DiscordApiHttpService>()
      .destroy(url: '/channels/$_channelId/messages/$id')
      .build();
  }
}
