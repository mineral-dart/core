import 'package:mineral/api/common/types/channel_type.dart';
import 'package:mineral/api/server/channels/server_forum_channel.dart';
import 'package:mineral/domains/marshaller/marshaller.dart';
import 'package:mineral/domains/marshaller/types/channel_factory.dart';

final class ServerForumChannelFactory implements ChannelFactoryContract<ServerForumChannel> {
  @override
  ChannelType get type => ChannelType.guildForum;

  @override
  Future<ServerForumChannel> make(MarshallerContract storage, String guildId, Map<String, dynamic> json) async {
    return ServerForumChannel.fromJson(guildId, json);
  }

  @override
  Map<String, dynamic> deserialize(ServerForumChannel channel) {
    return {
      'id': channel.id.value,
      'type': channel.type.value,
    };
  }
}
