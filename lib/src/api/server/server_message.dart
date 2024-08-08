import 'package:mineral/api/common/embed/message_embed.dart';
import 'package:mineral/api/common/message.dart';
import 'package:mineral/api/common/message_properties.dart';
import 'package:mineral/api/common/snowflake.dart';
import 'package:mineral/api/common/types/channel_type.dart';
import 'package:mineral/api/server/channels/server_channel.dart';
import 'package:mineral/api/server/channels/server_text_channel.dart';
import 'package:mineral/api/server/member.dart';
import 'package:mineral/api/server/server.dart';
import 'package:mineral/infrastructure/internals/container/ioc_container.dart';
import 'package:mineral/infrastructure/internals/datastore/data_store.dart';
import 'package:mineral/infrastructure/internals/datastore/parts/server_message_part.dart';

final class ServerMessage extends Message<ServerChannel> {
  ServerMessagePart get _dataStoreServerMessage => ioc.resolve<DataStoreContract>().serverMessage;
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

  Future<void> edit(String? content, List<MessageEmbed>? embeds, List<MessageComponent>? components) async {
    _dataStoreServerMessage.update(id: id, channelId: channelId, content: content, embeds: embeds, components: components);
  }

  Future<void> reply({String? content, List<MessageEmbed>? embeds}) async {
    _dataStoreServerMessage.reply(
        id: id, channelId: channelId, serverId: channel.guildId, content: content, embeds: embeds);
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
