import 'package:mineral/api.dart';
import 'package:mineral/src/api/channels/partial_channel.dart';
import 'package:mineral/src/api/components/component.dart';
import 'package:mineral/src/api/messages/message_attachment.dart';
import 'package:mineral/src/api/messages/message_sticker_item.dart';

class PartialMessage<T extends PartialChannel> {
  final Snowflake _id;
  String content;
  final bool _tts;
  List<MessageEmbed> embeds;
  final bool _allowMentions;
  final PartialMessage? _reference;
  List<Component> components;
  final List<MessageStickerItem> _stickers;
  final dynamic _payload;
  final List<MessageAttachment> _attachments;
  final int? _flags;
  final Snowflake _channelId;
  final T _channel;

  PartialMessage(
    this._id,
    this.content,
    this._tts,
    this.embeds,
    this._allowMentions,
    this._reference,
    this.components,
    this._stickers,
    this._payload,
    this._attachments,
    this._flags,
    this._channelId,
    this._channel,
  );

  Snowflake get id => _id;
  bool get tts => _tts;
  bool get allowMentions => _allowMentions;
  PartialMessage? get reference => _reference;
  List<MessageStickerItem> get stickers => _stickers;
  dynamic get payload => _payload;
  List<MessageAttachment> get attachments => _attachments;
  int? get flags => _flags;
  Snowflake get channelId => _channelId;
  T get channel => _channel;
}
