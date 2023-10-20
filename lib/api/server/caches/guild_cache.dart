import 'package:mineral/api/common/collection.dart';
import 'package:mineral/api/common/contracts/cache_contract.dart';
import 'package:mineral/api/common/contracts/presence_contracts.dart';
import 'package:mineral/api/common/emojis/emoji.dart';
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
          ChannelsType.guildText => GuildTextChannel.fromWss(payload, guild),
          ChannelsType.guildVoice => GuildVoiceChannel.fromWss(payload, guild),
          ChannelsType.guildNews => GuildAnnouncementChannel.fromWss(payload, guild),
          ChannelsType.guildCategory => GuildCategoryChannel.fromWss(payload, guild),
          ChannelsType.guildForum => GuildTextChannel.fromWss(payload, guild), // todo: implement guild forum channel
          _ => throw Exception("Unknown channel type: ${payload['type']}")
        };

        guild.channels.cache.putIfAbsent(
            Snowflake(payload['id']),
            () => channel
        );
      }

      for (final payload in payload['roles']) {
        guild.roles.cache.putIfAbsent(
            Snowflake(payload['id']),
            () => Role.fromWss(payload)
        );
      }

      for (final payload in payload['members']) {
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

      for(final payload in payload['emojis']) {
        guild.emojis.cache.putIfAbsent(
            Snowflake(payload['id']),
            () => Emoji.fromWss(payload)
        );
      }

      return guild;
  }
}