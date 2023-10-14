import 'package:mineral/api/server/contracts/channels/guild_channel_contracts.dart';

abstract interface class GuildCategoryChannelContracts implements GuildChannelContract {
  List<GuildChannelContract> getChannels();
}