import 'package:mineral/api/common/message.dart';
import 'package:mineral/api/private/channels/private_channel.dart';
import 'package:mineral/api/private/private_message.dart';
import 'package:mineral/api/server/channels/server_channel.dart';
import 'package:mineral/infrastructure/internals/marshaller/factories/messages/private_message_factory.dart';
import 'package:mineral/infrastructure/internals/marshaller/factories/messages/server_message_factory.dart';
import 'package:mineral/infrastructure/internals/marshaller/marshaller.dart';
import 'package:mineral/infrastructure/internals/marshaller/types/message_factory.dart';
import 'package:mineral/infrastructure/internals/marshaller/types/serializer.dart';

final class MessageSerializer implements SerializerContract<Message> {
  final MarshallerContract marshaller;

  final _serverMessageFactory = ServerMessageFactory();
  final _privateMessageFactory = PrivateMessageFactory();

  MessageSerializer(this.marshaller);

  @override
  Future<Message> serialize(Map<String, dynamic> json) async {
    final channel = await marshaller.dataStore.channel.getChannel(json['channel_id']);
    final factory = switch(channel) {
      ServerChannel() => _serverMessageFactory,
      PrivateChannel() => _privateMessageFactory,
      _ => throw Exception('Message type not found ${channel.runtimeType}'),
    } as MessageFactory;

    return factory.serialize(marshaller, json);
  }

  @override
  Future<Map<String, dynamic>> deserialize(Message object) {
    return switch(object) {
      ServerMessage() => _serverMessageFactory.deserialize(marshaller, object),
      PrivateMessage() => _privateMessageFactory.deserialize(marshaller, object),
      _ => throw Exception('Message type not found ${object.runtimeType}'),
    };
  }
}
