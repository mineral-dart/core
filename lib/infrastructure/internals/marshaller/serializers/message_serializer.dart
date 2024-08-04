import 'package:mineral/api/common/snowflake.dart';
import 'package:mineral/api/private/channels/private_channel.dart';
import 'package:mineral/api/server/channels/server_channel.dart';
import 'package:mineral/infrastructure/internals/marshaller/factories/messages/private_message_factory.dart';
import 'package:mineral/infrastructure/internals/marshaller/factories/messages/server_message_factory.dart';
import 'package:mineral/infrastructure/internals/marshaller/marshaller.dart';
import 'package:mineral/infrastructure/internals/marshaller/types/message_factory.dart';
import 'package:mineral/infrastructure/internals/marshaller/types/serializer.dart';

final class MessageSerializer implements SerializerContract {
  final MarshallerContract marshaller;

  final _serverMessageFactory = ServerMessageFactory();
  final _privateMessageFactory = PrivateMessageFactory();

  MessageSerializer(this.marshaller);

  @override
  Future serializeRemote(Map<String, dynamic> json) async {
    final serverId = json['message_reference']?['guild_id'];
    final channel = await marshaller.dataStore.channel.getChannel(Snowflake(json['channel_id']),
        serverId: serverId != null ? Snowflake(serverId) : null);

    final factory = switch (channel) {
      ServerChannel() => _serverMessageFactory,
      PrivateChannel() => _privateMessageFactory,
      _ => throw Exception('Channel type not found ${channel.runtimeType}'),
    } as MessageFactory;

    return factory.serializeRemote(marshaller, json);
  }

  @override
  Future serializeCache(Map<String, dynamic> json) {
    throw UnimplementedError();
  }

  @override
  Map<String, dynamic> deserialize(dynamic object) {
    return {
      'id': object.id,
    };
  }
}
