import 'package:mineral/api/common/contracts/channel_contract.dart';
import 'package:mineral/api/common/snowflake.dart';
import 'package:mineral/api/server/contracts/guild_contracts.dart';

abstract interface class GuildChannelContract implements ChannelContract {
  abstract final Snowflake guildId;
  abstract final int? position;
  abstract final GuildContract guild;

  Future<void> setName(String name, { String? reason });
  Future<void> delete({ String? reason });
  Future<void> setPosition(int position, { String? reason });
}