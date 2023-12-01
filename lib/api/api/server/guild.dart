import 'package:mineral/api/api/common/emoji.dart';
import 'package:mineral/api/api/server/channels/guild_channel.dart';
import 'package:mineral/api/api/server/channels/guild_text_channel.dart';
import 'package:mineral/api/api/server/channels/guild_voice_channel.dart';
import 'package:mineral/api/api/server/guild_member.dart';
import 'package:mineral/api/api/server/role.dart';

final class Guild {
  final String id;
  final String name;
  final String? description;
  final String region;
  final String ownerId;
  final GuildMember member;
  final String? bitfieldPermission;
  final String? afkChannelId;
  final GuildVoiceChannel afkChannel;
  final int? afkTimeout;
  final bool hasWidgetEnabled;
  final String? widgetChannelId;
  final int? verificationLevel;
  final int defaultMessageNotifications;
  final int explicitContentFilter;
  final Map<String, Role> roles;
  final Map<String, Emoji> emojis;
  final Map<String, dynamic> features;
  final Map<String, dynamic> stickers;
  final Map<String, GuildChannel> channels;
  final int mfaLevel;
  final String? applicationId;
  final String? systemChannelId;
  final GuildTextChannel systemChannel;
  final int? systemChannelFlags;
  final String? rulesChannelId;
  final GuildTextChannel rulesChannel;
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
  final GuildTextChannel publicUpdatesChannel;
  final int? maxVideoChannelUsers;
  final int? approximateMemberCount;
  final int? approximatePresenceCount;
  final int? welcomeScreen;
  final int nsfwLevel;
  final bool premiumProgressBarEnabled;
  final String? safetyAlertsChannelId;
  final GuildTextChannel safetyAlertsChannel;

  Guild({
    required this.id,
    required this.name,
    required this.region,
    required this.ownerId,
    required this.member,
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
    required this.welcomeScreen,
    required this.safetyAlertsChannelId,
    required this.safetyAlertsChannel,
  });
}
