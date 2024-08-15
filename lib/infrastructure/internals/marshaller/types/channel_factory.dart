import 'package:mineral/api/common/channel.dart';
import 'package:mineral/api/common/types/channel_type.dart';
import 'package:mineral/infrastructure/internals/marshaller/marshaller.dart';

abstract interface class ChannelFactoryContract<T extends Channel> {
  ChannelType get type;
  Future<T> serializeRemote(MarshallerContract marshaller, String guildId, Map<String, dynamic> json);
  Future<T> serializeCache(MarshallerContract marshaller, String guildId, Map<String, dynamic> json);
  Future<Map<String, dynamic>> deserialize(MarshallerContract marshaller, T channel);
}
