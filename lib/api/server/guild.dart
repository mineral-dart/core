import 'package:mineral/api/server/collections/guild_channel_collection.dart';
import 'package:mineral/api/server/collections/guild_emoji_collection.dart';
import 'package:mineral/api/server/collections/guild_member_collection.dart';
import 'package:mineral/api/server/collections/role_collection.dart';
import 'package:mineral/api/server/collections/sticker_collection.dart';
import 'package:mineral/api/server/guild_assets.dart';
import 'package:mineral/api/server/guild_member.dart';
import 'package:mineral/api/server/guild_settings.dart';
import 'package:mineral/api/server/role.dart';

final class Guild {
  final String id;
  final String name;
  final String? description;
  final GuildMember owner;
  final GuildMemberCollection members;
  final GuildMemberCollection bots;
  final GuildSettings settings;
  final RoleCollection roles;
  final GuildEmojiCollection emojis;
  final StickerCollection stickers;
  final GuildChannelCollection channels;
  final String? applicationId;
  final GuildAsset assets;

  Guild({
    required this.id,
    required this.name,
    required this.members,
    required this.bots,
    required this.settings,
    required this.roles,
    required this.emojis,
    required this.stickers,
    required this.channels,
    required this.description,
    required this.applicationId,
    required this.assets,
    required this.owner,
  });

  factory Guild.fromJson(Map<String, dynamic> json) {
    final roles = RoleCollection(Map<String, Role>.from(json['roles'].fold({}, (value, element) {
      final role = Role.fromJson(element);
      return {...value, role.id: role};
    })));

    List<Map<String, dynamic>> filterMember(bool isBot) {
      return List<Map<String, dynamic>>.from(
          json['members'].where((element) => element['user']['bot'] == isBot));
    }

    final members =
        GuildMemberCollection.fromJson(guildId: json['id'], roles: roles, json: filterMember(false))
          ..maxInGuild = json['max_members'];

    final bots =
        GuildMemberCollection.fromJson(guildId: json['id'], roles: roles, json: filterMember(true));

    final emojis = GuildEmojiCollection.fromJson(roles: roles, json: json['emojis']);

    final channels = GuildChannelCollection.fromJson(guildId: json['id'], json: json);

    final guild = Guild(
        id: json['id'],
        name: json['name'],
        members: members,
        bots: bots,
        settings: GuildSettings.fromJson(json),
        roles: roles,
        emojis: emojis,
        stickers: StickerCollection.fromJson(json['stickers']),
        channels: channels,
        description: json['description'],
        applicationId: json['application_id'],
        assets: GuildAsset.fromJson(json),
        owner: members.getOrFail(json['owner_id']));

    for (final channel in guild.channels.list.values) {
      channel.guild = guild;
    }

    return guild;
  }
}
