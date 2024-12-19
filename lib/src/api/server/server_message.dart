import 'package:mineral/api.dart';
import 'package:mineral/container.dart';
import 'package:mineral/contracts.dart';

final class ServerMessage extends Message<ServerChannel> {
  ServerMessagePartContract get _dataStoreServerMessage =>
      ioc.resolve<DataStoreContract>().serverMessage;
  final MessageProperties<ServerChannel> _properties;

  @override
  Snowflake get id => _properties.id;

  @override
  String get content => _properties.content;

  List<MessageEmbed> get embeds => _properties.embeds;

  @override
  Snowflake get channelId => _properties.channelId;

  @override
  late final ServerChannel channel;

  DateTime get createdAt => _properties.createdAt;

  DateTime? get updatedAt => _properties.updatedAt;

  final Member author;

  ServerMessage(
    this._properties, {
    required this.author,
  });

  /// Edit the message.
  ///
  /// ```dart
  /// await message.edit('New content', embeds: [embed], components: [component]);
  /// ```
  Future<void> edit(String? content, List<MessageEmbed>? embeds,
      List<MessageComponent>? components) async {
    _dataStoreServerMessage.update(
        id: id,
        channelId: channelId,
        serverId: channel.serverId,
        content: content,
        embeds: embeds,
        components: components);
  }

  /// Reply to the original message.
  ///
  /// ```dart
  /// await message.reply(content: 'Replying to the message');
  /// ```
  Future<void> reply(
      {String? content,
      List<MessageEmbed>? embeds,
      List<MessageComponent>? components}) async {
    _dataStoreServerMessage.reply(
        id: id,
        channelId: channelId,
        serverId: channel.serverId,
        content: content,
        embeds: embeds,
        components: components);
  }

  /// Pin the message.
  ///
  /// ```dart
  /// await message.pin();
  /// ```
  Future<void> pin() async {
    await _dataStoreServerMessage.pin(id: id, channelId: channelId);
  }

  /// Unpin the message.
  ///
  /// ```dart
  /// await message.unpin();
  /// ```
  Future<void> unpin() async {
    await _dataStoreServerMessage.unpin(id: id, channelId: channelId);
  }

  /// Crosspost the message.
  ///
  /// ```dart
  /// await message.crosspost(); // only works for guild announcements
  /// ```
  Future<void> crosspost() async {
    if (channel.type != ChannelType.guildAnnouncement) {
      return;
    }

    await _dataStoreServerMessage.crosspost(id: id, channelId: channelId);
  }

  /// Delete the message.
  ///
  /// ```dart
  /// await message.delete();
  /// ```
  Future<void> delete() async {
    await _dataStoreServerMessage.delete(id: id, channelId: channelId);
  }

// todo: addReaction, removeReaction, removeAllReactions, getReactions, clearReactions
}
