import 'package:mineral/api.dart';
import 'package:mineral/src/infrastructure/internals/container/ioc_container.dart';
import 'package:mineral/src/infrastructure/internals/datastore/data_store.dart';
import 'package:mineral/src/infrastructure/internals/datastore/parts/server_message_part.dart';

final class ServerMessage extends Message<ServerChannel> {
  ServerMessagePart get _dataStoreServerMessage =>
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

  final Poll? poll;

  ServerMessage(
    this._properties, {
    required this.author,
    required this.poll,
  });

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

  Future<void> pin() async {
    await _dataStoreServerMessage.pin(id: id, channelId: channelId);
  }

  Future<void> unpin() async {
    await _dataStoreServerMessage.unpin(id: id, channelId: channelId);
  }

  Future<void> crosspost() async {
    if (channel.type != ChannelType.guildAnnouncement) {
      return;
    }

    await _dataStoreServerMessage.crosspost(id: id, channelId: channelId);
  }

  Future<void> delete() async {
    await _dataStoreServerMessage.delete(id: id, channelId: channelId);
  }
}
