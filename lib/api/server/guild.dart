import 'package:mineral/api/common/resources/image.dart';
import 'package:mineral/api/common/snowflake.dart';
import 'package:mineral/api/common/user/user.dart';
import 'package:mineral/api/server/caches/guild_channels_cache.dart';
import 'package:mineral/api/server/caches/guild_emojis_cache.dart';
import 'package:mineral/api/server/caches/guild_members_cache.dart';
import 'package:mineral/api/server/caches/guild_roles_cache.dart';
import 'package:mineral/api/server/contracts/channels/guild_text_channel_contracts.dart';
import 'package:mineral/api/server/contracts/guild_contracts.dart';
import 'package:mineral/api/server/contracts/channels/guild_voice_channel_contracts.dart';
import 'package:mineral/api/server/resources/enums.dart';
import 'package:mineral/api/server/resources/vanity.dart';

final class Guild implements GuildContract {
  @override
  final Snowflake id;

  @override
  final String label;

  @override
  final String? description;

  @override
  final String ownerId;

  @override
  late final GuildMemberCache members;

  @override
  late final GuildRolesCache roles;

  @override
  late final GuildChannelsCache channels;

  @override
  late final GuildEmojisCache emojis;

  @override
  final Image? icon;

  @override
  final Image? banner;

  @override
  final Image? splash;

  final String? afkChannelId;

  final int? afkTimeout;

  @override
  final String? rulesChannelId;

  @override
  final String? publicUpdatesChannelId;

  @override
  final String? safetyAlertsChannelId;

  @override
  final String? systemChannelId;

  @override
  final int? systemChannelFlags;

  @override
  final bool? widgetEnabled;

  @override
  final String? widgetChannelId;

  @override
  final VerificationLevel verificationLevel;

  @override
  final NotificationLevel defaultNotificationLevel;

  @override
  final ContentFilterLevel explicitContentFilter;

  @override
  final NsfwLevel nsfwLevel;

  @override
  final MfaLevel mfaLevel;

  @override
  final PremiumTier premiumTier;

  @override
  final Locale preferredLocale;

  @override
  final List<GuildFeature> features;

  @override
  final Vanity? vanity;

  @override
  final String? applicationId;

  @override
  final int? maxPresences;

  @override
  final int? maxMembers;

  @override
  final int? premiumSubscriptionCount;

  @override
  final int? maxVideoChannelUsers;

  @override
  final int? maxStageVideoChannelUsers;

  @override
  final int? approximateMemberCount;

  @override
  final int? approximatePresenceCount;

  @override
  final bool premiumProgressBarEnabled;

  Guild._({
    required this.id,
    required this.label,
    required this.description,
    required this.ownerId,
    required this.icon,
    required this.banner,
    required this.splash,
    required this.afkChannelId,
    required this.afkTimeout,
    required this.rulesChannelId,
    required this.systemChannelId,
    required this.publicUpdatesChannelId,
    required this.systemChannelFlags,
    required this.safetyAlertsChannelId,
    required this.widgetEnabled,
    required this.widgetChannelId,
    required this.verificationLevel,
    required this.defaultNotificationLevel,
    required this.explicitContentFilter,
    required this.nsfwLevel,
    required this.mfaLevel,
    required this.premiumTier,
    required this.preferredLocale,
    required this.features,
    required this.applicationId,
    required this.maxPresences,
    required this.maxMembers,
    required this.premiumSubscriptionCount,
    required this.maxVideoChannelUsers,
    required this.maxStageVideoChannelUsers,
    required this.approximateMemberCount,
    required this.approximatePresenceCount,
    required this.premiumProgressBarEnabled,
    required this.vanity,
  }) {
    members = GuildMemberCache(this);
    channels = GuildChannelsCache(this);
    roles = GuildRolesCache(this);
    emojis = GuildEmojisCache(this);
  }

  GuildTextChannelContract? get systemChannel => channels.cache.get(systemChannelId.toSnowflake()) as GuildTextChannelContract?;
  GuildTextChannelContract? get publicUpdatesChannel => channels.cache.get(publicUpdatesChannelId.toSnowflake()) as GuildTextChannelContract?;
  GuildTextChannelContract? get safetyAlertsChannel => channels.cache.get(safetyAlertsChannelId.toSnowflake()) as GuildTextChannelContract?;
  GuildTextChannelContract? get widgetChannel => channels.cache.get(widgetChannelId.toSnowflake()) as GuildTextChannelContract?;
  GuildTextChannelContract? get rulesChannel => channels.cache.get(rulesChannelId.toSnowflake()) as GuildTextChannelContract?;
  GuildVoiceChannelContract? get afkChannel => channels.cache.get(afkChannelId.toSnowflake()) as GuildVoiceChannelContract?;

  User get owner => members.cache.getOrFail(Snowflake(ownerId)).user;

  /// [Guild] to Json method is private
  dynamic _toJson() {
    return {
      "name": label,
      "description": description,
      "icon": icon,
      "banner": banner,
      "verification_level": verificationLevel.value,
      "default_message_notifications": defaultNotificationLevel.value,
      "explicit_content_filter": explicitContentFilter.value,
      "afk_channel_id": afkChannelId,
      "afk_timeout": afkTimeout,
      "owner_id": ownerId,
      "splash": splash,
      "discovery_splash": splash,
      "system_channel_id": systemChannelId,
      "system_channel_flags": systemChannelFlags,
      "rules_channel_id": rulesChannelId,
      "public_updates_channel_id": publicUpdatesChannelId,
      "preferred_locale": preferredLocale.locale,
      "features": features.map((e) => e.name),
      "premium_progress_bar_enabled": premiumProgressBarEnabled,
      "safety_alerts_channel_id": safetyAlertsChannelId,
    };
  }

  // not tested
  factory Guild.fromWss(final payload) {
    List<GuildFeature> features = [];

    if (payload["features"] != null) {
      for (final feature in payload["features"]) {
        GuildFeature? guildFeature = GuildFeature.get(feature);
        if (guildFeature != null) features.add(guildFeature);
      }
    }

    return Guild._(
        id: payload["id"].toString().toSnowflake(),
        label: payload["name"],
        description: payload["description"],
        ownerId: payload["owner_id"],
        icon: Image(label: payload["icon"], endpoint: "icons/${payload["id"]}/"),
        banner: Image(label: payload["banner"], endpoint: "banners/${payload["id"]}/"),
        splash: Image(label: payload["splash"], endpoint: "splashes/${payload["id"]}/"),
        afkChannelId: payload["afk_channel_id"],
        afkTimeout: payload["afk_timeout"],
        rulesChannelId: payload["rules_channel_id"],
        systemChannelId: payload["system_channel_id"],
        publicUpdatesChannelId: payload["public_updates_channel_id"],
        systemChannelFlags: payload["system_channel_flags"],
        safetyAlertsChannelId: payload["safety_alerts_channel_id"],
        widgetEnabled: payload["widget_enabled"],
        widgetChannelId: payload["widget_channel_id"],
        verificationLevel: VerificationLevel.from(payload["verification_level"]),
        defaultNotificationLevel: NotificationLevel.of(payload["default_message_notifications"]),
        explicitContentFilter: ContentFilterLevel.of(payload["explicit_content_filter"]),
        nsfwLevel: NsfwLevel.of(payload["nsfw_level"]),
        mfaLevel: MfaLevel.of(payload["mfa_level"]),
        premiumTier: PremiumTier.of(payload["premium_tier"]),
        preferredLocale: Locale.from(payload["preferred_locale"]),
        features: features,
        applicationId: payload["application_id"],
        maxPresences: payload["max_presences"],
        maxMembers: payload["max_members"],
        premiumSubscriptionCount: payload["premium_subscription_count"],
        maxVideoChannelUsers: payload["max_video_channel_users"],
        maxStageVideoChannelUsers: payload["max_stage_video_channel_users"],
        approximateMemberCount: payload["approximate_member_count"],
        approximatePresenceCount: payload["approximate_presence_count"],
        premiumProgressBarEnabled: payload["premium_progress_bar_enabled"],
        vanity: payload['vanity_url_code'] != null ? Vanity(payload["vanity_url_code"], null) : null,
    );
  }
}