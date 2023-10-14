import 'package:mineral/api/common/collection.dart';
import 'package:mineral/api/common/contracts/cache_contract.dart';
import 'package:mineral/api/common/contracts/presence_contracts.dart';
import 'package:mineral/api/common/snowflake.dart';
import 'package:mineral/api/common/user/presence.dart';
import 'package:mineral/api/server/channels/guild_announcement_channel.dart';
import 'package:mineral/api/server/channels/guild_category_channel.dart';
import 'package:mineral/api/server/channels/guild_text_channel.dart';
import 'package:mineral/api/server/channels/guild_voice_channel.dart';
import 'package:mineral/api/server/contracts/guild_contracts.dart';
import 'package:mineral/api/server/contracts/guild_member_contracts.dart';
import 'package:mineral/api/server/guild.dart';
import 'package:mineral/api/server/guild_member.dart';
import 'package:mineral/api/server/resources/channel_type.dart';
import 'package:mineral/api/server/role.dart';

final class GuildCache implements CacheContract<GuildContract> {
  @override
  final Collection<Snowflake, GuildContract> cache = Collection();

  @override
  Future<GuildContract> resolve(Snowflake id) async {
    return cache.getOrFail(id);
  }

  Guild from(final payload) {
      Guild guild = Guild.fromWss(payload);

      for (final payload in payload['channels']) {
        final channel = switch(ChannelsType.values.where((element) => element.value == payload['type']).first) {
          ChannelsType.guildText => GuildTextChannel.fromWss(payload),
          ChannelsType.guildVoice => GuildVoiceChannel.fromWss(payload),
          ChannelsType.guildNews => GuildAnnouncementChannel.fromWss(payload),
          ChannelsType.guildCategory => GuildCategoryChannel.fromWss(payload, guild.id),
          ChannelsType.guildForum => GuildTextChannel.fromWss(payload), // todo: implement guild forum channel
          _ => throw Exception("Unknown channel type: ${payload['type']}")
        };

        guild.channels.cache.putIfAbsent(Snowflake(payload['id']), () => channel);
      }

      for(final payload in payload['roles']) {
        guild.roles.cache.putIfAbsent(
            Snowflake(payload['id']),
            () => Role.fromWss(payload)
        );
      }

      for(final payload in payload['members']) {
        guild.members.cache.putIfAbsent(
            Snowflake(payload['user']['id']),
            () => GuildMember.fromWss(payload, guild)
        );
      }

      for(final payload in payload['presences']) {
        PresenceContracts presence = Presence.fromWss(payload);
        GuildMemberContract member = guild.members.cache.getOrFail(Snowflake(payload['user']['id']));

        member.presence = presence;
      }

      cache.putIfAbsent(guild.id, () => guild);

      print("Roles: ${guild.roles.cache.length}");
      print("Guild: ${guild.label}");
      print("Channels: ${guild.channels.cache.length}");
      print("Members: ${guild.members.cache.length}");
      print("Presences: ${guild.members.cache.values.where((member) => member.presence != null).map((e) => e.presence!.activities.length).reduce((value, element) => value + element)}");
      print("Guilds in client's cache: ${cache.length}");

      return guild;
  }


}