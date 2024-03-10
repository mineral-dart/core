import 'package:mineral/api/common/types/channel_type.dart';
import 'package:mineral/api/server/channels/server_text_channel.dart';
import 'package:mineral/domains/marshaller/marshaller.dart';
import 'package:mineral/domains/marshaller/types/channel_factory.dart';

final class ServerTextChannelFactory implements ChannelFactoryContract<ServerTextChannel> {
  @override
  ChannelType get type => ChannelType.guildText;

  @override
  Future<ServerTextChannel> make(MarshallerContract marshaller, String guildId, Map<String, dynamic> json) async {
    return ServerTextChannel.fromJson(marshaller, guildId, json);
  }
}
