import 'package:mineral/api/common/types/channel_type.dart';
import 'package:mineral/api/server/channels/server_text_channel.dart';
import 'package:mineral/domains/data/factories/channel_factory.dart';

final class ServerTextChannelFactory implements ChannelFactoryContract<ServerTextChannel> {
  @override
  ChannelType get type => ChannelType.guildText;

  @override
  ServerTextChannel make(String guildId, Map<String, dynamic> json) {
    return ServerTextChannel.fromJson(guildId, json);
  }
}
