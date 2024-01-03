import 'package:mineral/api/common/channel.dart';
import 'package:mineral/api/server/channels/guild_text_channel.dart';
import 'package:mineral/api/server/channels/guild_voice_channel.dart';
import 'package:mineral/api/server/collections/guild_channel_collection.dart';
import 'package:mineral/api/server/collections/guild_emoji_collection.dart';
import 'package:mineral/api/server/collections/guild_member_collection.dart';
import 'package:mineral/api/server/collections/role_collection.dart';
import 'package:mineral/api/server/collections/sticker_collection.dart';
import 'package:mineral/api/server/enums/default_message_notification.dart';
import 'package:mineral/api/server/enums/explicit_content_filter.dart';
import 'package:mineral/api/server/enums/mfa_level.dart';
import 'package:mineral/api/server/enums/system_channel_flag.dart';
import 'package:mineral/api/server/enums/verification_level.dart';
import 'package:mineral/api/server/guild_member.dart';
import 'package:mineral/api/server/role.dart';
import 'package:mineral/domains/shared/utils.dart';

final class Guild {
  final String id;
  final String name;
  final String? description;
  final String ownerId;
  final GuildMember owner;
  final GuildMemberCollection members;
  final GuildMemberCollection bots;
  final String? bitfieldPermission;
  final String? afkChannelId;
  final GuildVoiceChannel? afkChannel;
  final int? afkTimeout;
  final bool hasWidgetEnabled;
  final String? widgetChannelId;
  final VerificationLevel verificationLevel;
  final DefaultMessageNotification defaultMessageNotifications;
  final ExplicitContentFilter explicitContentFilter;
  final RoleCollection roles;
  final GuildEmojiCollection emojis;
  final List<String> features;
  final StickerCollection stickers;
  final GuildChannelCollection channels;
  final MfaLevel mfaLevel;
  final String? applicationId;
  final String? systemChannelId;
  final GuildTextChannel? systemChannel;
  final List<SystemChannelFlag> systemChannelFlags;
  final String? rulesChannelId;
  final GuildTextChannel? rulesChannel;
  final int maxMembers;
  final String? vanityUrlCode;
  final String? banner;
  final String? icon;
  final String? splash;
  final String? discoverySplash;
  final int premiumTier;
  final int? premiumSubscriptionCount;
  final String preferredLocale;
  final String? publicUpdatesChannelId;
  final GuildTextChannel? publicUpdatesChannel;
  final int? maxVideoChannelUsers;
  final int? approximateMemberCount;
  final int? approximatePresenceCount;
  final int nsfwLevel;
  final bool premiumProgressBarEnabled;
  final String? safetyAlertsChannelId;
  final GuildTextChannel? safetyAlertsChannel;

  Guild({
    required this.id,
    required this.name,
    required this.ownerId,
    required this.members,
    required this.bots,
    required this.hasWidgetEnabled,
    required this.defaultMessageNotifications,
    required this.explicitContentFilter,
    required this.roles,
    required this.emojis,
    required this.features,
    required this.stickers,
    required this.channels,
    required this.mfaLevel,
    required this.maxMembers,
    required this.premiumTier,
    required this.preferredLocale,
    required this.nsfwLevel,
    required this.premiumProgressBarEnabled,
    required this.description,
    required this.bitfieldPermission,
    required this.afkChannelId,
    required this.afkChannel,
    required this.afkTimeout,
    required this.widgetChannelId,
    required this.verificationLevel,
    required this.applicationId,
    required this.systemChannelId,
    required this.systemChannel,
    required this.systemChannelFlags,
    required this.rulesChannelId,
    required this.rulesChannel,
    required this.vanityUrlCode,
    required this.banner,
    required this.icon,
    required this.splash,
    required this.discoverySplash,
    required this.premiumSubscriptionCount,
    required this.publicUpdatesChannelId,
    required this.publicUpdatesChannel,
    required this.maxVideoChannelUsers,
    required this.approximateMemberCount,
    required this.approximatePresenceCount,
    required this.safetyAlertsChannelId,
    required this.safetyAlertsChannel,
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

    final members = GuildMemberCollection.fromJson(
        guildId: json['id'], roles: roles, json: filterMember(false));

    final bots =
        GuildMemberCollection.fromJson(guildId: json['id'], roles: roles, json: filterMember(true));

    final emojis = GuildEmojiCollection.fromJson(roles: roles, json: json['emojis']);

    final channels = GuildChannelCollection.fromJson(guildId: json['id'], json: json['channels']);

    final Channel? afkChannel = channels.getOrNull(json['afk_channel_id']);

    final Channel? systemChannel = channels.getOrNull(json['system_channel_id']);

    final Channel? rulesChannel = channels.getOrNull(json['rules_channel_id']);

    final Channel? publicUpdatesChannel = channels.getOrNull(json['public_updates_channel_id']);

    final Channel? safetyAlertsChannel = channels.getOrNull(json['safety_alerts_channel_id']);

    final guild = Guild(
        id: json['id'],
        name: json['name'],
        ownerId: json['owner_id'],
        members: members,
        bots: bots,
        hasWidgetEnabled: json['widget_enabled'] ?? false,
        defaultMessageNotifications: DefaultMessageNotification.values
            .firstWhere((element) => element.value == json['default_message_notifications']),
        explicitContentFilter: ExplicitContentFilter.values
            .firstWhere((element) => element.value == json['explicit_content_filter']),
        roles: roles,
        emojis: emojis,
        features: List<String>.from(json['features']),
        stickers: StickerCollection.fromJson(json['stickers']),
        channels: channels,
        mfaLevel: MfaLevel.values.firstWhere((element) => element.value == json['mfa_level']),
        maxMembers: json['max_members'],
        premiumTier: json['premium_tier'],
        preferredLocale: json['preferred_locale'],
        nsfwLevel: json['nsfw_level'],
        premiumProgressBarEnabled: json['premium_progress_bar_enabled'],
        description: json['description'],
        bitfieldPermission: json['permissions'],
        afkChannelId: json['afk_channel_id'],
        afkChannel: afkChannel as GuildVoiceChannel?,
        afkTimeout: json['afk_timeout'],
        widgetChannelId: json['widget_channel_id'],
        verificationLevel: VerificationLevel.values
            .firstWhere((element) => element.value == json['verification_level']),
        applicationId: json['application_id'],
        systemChannelId: json['system_channel_id'],
        systemChannel: systemChannel as GuildTextChannel?,
        systemChannelFlags: bitfieldToList(SystemChannelFlag.values, json['system_channel_flags']),
        rulesChannelId: json['rules_channel_id'],
        rulesChannel: rulesChannel as GuildTextChannel?,
        vanityUrlCode: json['vanity_url_code'],
        banner: json['banner'],
        icon: json['icon'],
        splash: json['splash'],
        discoverySplash: json['discovery_splash'],
        premiumSubscriptionCount: json['premium_subscription_count'],
        publicUpdatesChannelId: json['public_updates_channel_id'],
        publicUpdatesChannel: publicUpdatesChannel as GuildTextChannel?,
        maxVideoChannelUsers: json['max_video_channel_users'],
        approximateMemberCount: json['approximate_member_count'],
        approximatePresenceCount: json['approximate_presence_count'],
        safetyAlertsChannelId: json['safety_alerts_channel_id'],
        safetyAlertsChannel: safetyAlertsChannel as GuildTextChannel?,
        owner: members.getOrFail(json['owner_id']));

    return guild;
  }
}
