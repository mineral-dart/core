import 'package:mineral/src/domains/services/container/ioc_container.dart';
import 'package:mineral/src/api/common/channel.dart';
import 'package:mineral/src/api/common/message_properties.dart';
import 'package:mineral/src/api/server/channels/server_channel.dart';
import 'package:mineral/src/api/server/server_message.dart';
import 'package:mineral/src/infrastructure/internals/datastore/data_store.dart';
import 'package:mineral/src/infrastructure/internals/marshaller/marshaller.dart';
import 'package:mineral/src/infrastructure/internals/marshaller/types/message_factory.dart';

final class ServerMessageFactory implements MessageFactory<ServerMessage> {
  MarshallerContract get _marshaller => ioc.resolve<MarshallerContract>();
  DataStoreContract get _dataStore => ioc.resolve<DataStoreContract>();

  @override
  Future<ServerMessage> serialize(Map<String, dynamic> json) async {
    final channel = json['channel'] as Channel;
    final server = await _dataStore.server.getServer(json['guild_id']);
    final member = server.members.list[json['author']['id']];

    final messageProperties =
        MessageProperties.fromJson(channel as ServerChannel, json);

    return ServerMessage(messageProperties, author: member!);
  }

  @override
  Map<String, dynamic> deserialize(ServerMessage message) {
    return {
      'id': message.id,
      'content': message.content,
      'embeds': message.embeds
          .map(_marshaller.serializers.embed.deserialize)
          .toList(),
      'channel_id': message.channel.id,
      'guild_id': message.channel.serverId,
      'created_at': message.createdAt.toIso8601String(),
      'updated_at': message.updatedAt?.toIso8601String(),
    };
  }
}
