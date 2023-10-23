import 'package:mineral/api/server/builders/guild_category_channel_builder.dart';
import 'package:mineral/api/server/contracts/channels/guild_channel_contracts.dart';

abstract interface class GuildCategoryChannelContracts implements GuildChannelContract {
  Future<void> update (GuildCategoryChannelBuilder builder, { String? reason });
  List<GuildChannelContract> get channels;
}