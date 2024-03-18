import 'package:mineral/api/common/types/channel_type.dart';
import 'package:mineral/api/private/channels/private_channel.dart';
import 'package:mineral/domains/marshaller/marshaller.dart';
import 'package:mineral/domains/marshaller/types/channel_factory.dart';

final class PrivateChannelFactory implements ChannelFactoryContract<PrivateChannel> {
  @override
  ChannelType get type => ChannelType.dm;

  @override
  Future<PrivateChannel> make(MarshallerContract marshaller, String guildId, Map<String, dynamic> json) async {
    return PrivateChannel.fromJson(json);
  }

  @override
  Future<Map<String, dynamic>> deserialize(MarshallerContract marshaller, PrivateChannel channel) async {
    return {
      'id': channel.id.value,
      'type': channel.type.value,
    };
  }
}
