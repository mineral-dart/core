import 'package:mineral/api/common/channel.dart';
import 'package:mineral/api/server/server.dart';
import 'package:mineral/api/server/server_message.dart';
import 'package:mineral/domains/marshaller/marshaller.dart';
import 'package:mineral/domains/marshaller/serializers/channel_serializer.dart';
import 'package:mineral/domains/marshaller/serializers/server_message_serializer.dart';
import 'package:mineral/domains/marshaller/serializers/server_serializer.dart';
import 'package:mineral/domains/marshaller/types/serializer.dart';

abstract interface class SerializerBucket {
  SerializerContract<Channel> get channels;

  SerializerContract<Server> get server;

  SerializerContract<ServerMessage> get serverMessage;
}

final class SerializerBucketImpl<T> implements SerializerBucket {
  @override
  final SerializerContract<Channel> channels;

  @override
  final SerializerContract<Server> server;

  @override
  final SerializerContract<ServerMessage> serverMessage;

  SerializerBucketImpl(MarshallerContract marshaller)
      : channels = ChannelSerializer(marshaller),
        server = ServerSerializer(marshaller),
        serverMessage = ServerMessageSerializer(marshaller);
}
