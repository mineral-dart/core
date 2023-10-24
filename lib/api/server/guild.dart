import 'package:mineral/api/common/image.dart';
import 'package:mineral/api/common/resources/picture.dart';
import 'package:mineral/api/common/snowflake.dart';
import 'package:mineral/api/server/builders/guild_builder.dart';
import 'package:mineral/api/server/caches/guild_channels_cache.dart';
import 'package:mineral/api/server/caches/guild_emojis_cache.dart';
import 'package:mineral/api/server/caches/guild_members_cache.dart';
import 'package:mineral/api/server/caches/guild_roles_cache.dart';
import 'package:mineral/api/server/contracts/channels/guild_text_channel_contracts.dart';
import 'package:mineral/api/server/contracts/guild_contracts.dart';
import 'package:mineral/api/server/contracts/channels/guild_voice_channel_contracts.dart';
import 'package:mineral/api/server/contracts/guild_member_contracts.dart';
import 'package:mineral/api/server/resources/enums.dart';
import 'package:mineral/api/server/resources/vanity.dart';
import 'package:mineral/internal/services/http/discord_http_client.dart';
import 'package:mineral/services/http/entities/either.dart';
import 'package:mineral/services/http/entities/http_error.dart';

final class Guild implements GuildContract {
  @override
  final Snowflake id;

  @override
  final String name;

  @override
  final String? description;

  @override
  final Snowflake ownerId;

  @override
  late final GuildMemberCache members;

  @override
  late final GuildRolesCache roles;

  @override
  late final GuildChannelsCache channels;

  @override
  late final GuildEmojisCache emojis;

  @override
  final Picture? icon;

  @override
  final Picture? banner;

  @override
  final Picture? splash;

  final Snowflake? afkChannelId;

  final int? afkTimeout;

  @override
  final Snowflake? rulesChannelId;

  @override
  final Snowflake? publicUpdatesChannelId;

  @override
  final Snowflake? safetyAlertsChannelId;

  @override
  final Snowflake? systemChannelId;

  @override
  final int? systemChannelFlags;

  @override
  final bool? widgetEnabled;

  @override
  final Snowflake? widgetChannelId;

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
    required this.name,
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

  @override
  GuildTextChannelContract? get systemChannel => channels.cache.get(systemChannelId) as GuildTextChannelContract?;

  @override
  GuildTextChannelContract? get publicUpdatesChannel => channels.cache.get(publicUpdatesChannelId) as GuildTextChannelContract?;

  @override
  GuildTextChannelContract? get safetyAlertsChannel => channels.cache.get(safetyAlertsChannelId) as GuildTextChannelContract?;

  @override
  GuildTextChannelContract? get widgetChannel => channels.cache.get(widgetChannelId) as GuildTextChannelContract?;

  @override
  GuildTextChannelContract? get rulesChannel => channels.cache.get(rulesChannelId) as GuildTextChannelContract?;

  @override
  GuildVoiceChannelContract? get afkChannel => channels.cache.get(afkChannelId) as GuildVoiceChannelContract?;

  @override
  GuildMemberContract get owner => members.cache.getOrFail(ownerId);

  @override
  Future<void> setOwner (GuildMemberContract member, { String? reason }) async {
    final http = DiscordHttpClient.singleton();

    final request = http.patch('/guilds/${id.value}')
      .payload({ 'owner_id': member.user.id.value })
      .auditLog(reason)
      .build();

    await Either.future(
      future: request,
      onError: (HttpError error) => switch(error) {
        HttpError(message: final message)
          => throw ArgumentError(message),
      }
    );
  }

  @override
  Future<void> delete({ String? reason }) {
    final http = DiscordHttpClient.singleton();

    final request = http.delete('/guilds/${id.value}')
      .auditLog(reason)
      .build();

    return Either.future(
      future: request,
      onError: (HttpError error) => switch(error) {
        HttpError(message: final message)
          => throw ArgumentError(message),
      }
    );
  }

  @override
  Future<void> setAfkChannel(GuildVoiceChannelContract channel, { String? reason }) async {
    GuildBuilder builder = GuildBuilder();
    return update(builder.setAfkChannelId(channel.id), reason: reason);
  }

  @override
  Future<void> setAfkTimeout(int timeout, { String? reason }) async {
    GuildBuilder builder = GuildBuilder();
    return update(builder.setAfkTimeout(timeout), reason: reason);
  }

  @override
  Future<void> setDefaultNotificationLevel(NotificationLevel defaultNotificationLevel, { String? reason }) async {
    GuildBuilder builder = GuildBuilder();
    return update(builder.setDefaultMessageNotifications(defaultNotificationLevel), reason: reason);
  }

  @override
  Future<void> setExplicitContentFilter(ContentFilterLevel explicitContentFilter, { String? reason }) async {
    GuildBuilder builder = GuildBuilder();
    return update(builder.setExplicitContentFilter(explicitContentFilter), reason: reason);
  }

  @override
  Future<void> setIcon(Image icon, { String? reason }) async {
    GuildBuilder builder = GuildBuilder();
    return update(builder.setIcon(icon), reason: reason);
  }

  @override
  Future<void> removeIcon({ String? reason }) async {
    GuildBuilder builder = GuildBuilder();
    return update(builder.setIcon(null), reason: reason);
  }

  @override
  Future<void> setBanner(Image icon, { String? reason }) async {
    GuildBuilder builder = GuildBuilder();
    return update(builder.setBanner(icon), reason: reason);
  }

  @override
  Future<void> removeBanner({ String? reason }) async {
    GuildBuilder builder = GuildBuilder();
    return update(builder.setBanner(null), reason: reason);
  }

  @override
  Future<void> setSplash(Image icon, { String? reason }) async {
    GuildBuilder builder = GuildBuilder();
    return update(builder.setSplash(icon), reason: reason);
  }

  @override
  Future<void> removeSplash({ String? reason }) async {
    GuildBuilder builder = GuildBuilder();
    return update(builder.setSplash(null), reason: reason);
  }

  @override
  Future<void> setDiscoverySplash(Image icon, { String? reason }) async {
    GuildBuilder builder = GuildBuilder();
    return update(builder.setDiscoverySplash(icon), reason: reason);
  }

  @override
  Future<void> removeDiscoverySplash({ String? reason }) async {
    GuildBuilder builder = GuildBuilder();
    return update(builder.setDiscoverySplash(null), reason: reason);
  }

  @override
  Future<void> setName(String name, { String? reason }) async {
    GuildBuilder builder = GuildBuilder();
    return update(builder.setName(name), reason: reason);
  }

  @override
  Future<void> setNsfwLevel(NsfwLevel nsfwLevel, { String? reason }) async {
    GuildBuilder builder = GuildBuilder();
    return update(builder.setNsfwLevel(nsfwLevel), reason: reason);
  }

  @override
  Future<void> setRegion(String region, { String? reason }) async {
    GuildBuilder builder = GuildBuilder();
    return update(builder.setRegion(region), reason: reason);
  }

  @override
  Future<void> setVerificationLevel(VerificationLevel verificationLevel, { String? reason }) async {
    GuildBuilder builder = GuildBuilder();
    return update(builder.setVerificationLevel(verificationLevel), reason: reason);
  }

  @override
  Future<void> update(GuildBuilder builder, { String? reason }) async {
    final http = DiscordHttpClient.singleton();

    final request = http.patch("/guilds/${id.value}")
      .payload(builder.build())
      .build();

    await Either.future(
      future: request,
      onError: (HttpError error) => switch(error) {
        HttpError(message: final message)
          => throw ArgumentError(message),
      }
    );
  }

  @override
  Future<void> ban(GuildMemberContract member, { int? days, String? reason }) async {
    final http = DiscordHttpClient.singleton();

    final request = http.put('/guilds/$id/bans/${member.user.id}')
      .auditLog(reason)
      .payload({ 'delete_message_seconds': days })
      .build();

    await Either.future(
      future:request,
      onError: (HttpError error) => switch(error) {
        HttpError(message: final message)
          => throw ArgumentError(message),
      }
    );
  }

  @override
  Future<void> kick(GuildMemberContract member, { String? reason }) async {
    final http = DiscordHttpClient.singleton();

    final request = http.delete('/guilds/$id/members/${member.user.id}')
      .auditLog(reason)
      .build();

    await Either.future(
      future:request,
      onError: (HttpError error) => switch(error) {
        HttpError(message: final message)
          => throw ArgumentError(message),
      }
    );
  }

  @override
  Future<void> leave({ String? reason }) async {
    final http = DiscordHttpClient.singleton();

    final request = http.delete('/users/@me/guilds/$id')
      .auditLog(reason)
      .build();

    await Either.future(
      future:request,
      onError: (HttpError error) => switch(error) {
        HttpError(message: final message)
          => throw ArgumentError(message),
      }
    );
  }

  @override
  Future<void> unban(Snowflake id, { String? reason}) async {
    final http = DiscordHttpClient.singleton();

    final request = http.delete('/guilds/${this.id}/bans/$id')
      .auditLog(reason)
      .build();

    await Either.future(
      future:request,
      onError: (HttpError error) => switch(error) {
        HttpError(message: final message)
          => throw ArgumentError(message),
      }
    );
  }

  factory Guild.fromWss(final payload) {
    List<GuildFeature> features = [];

    if (payload["features"] != null) {
      for (final feature in payload["features"]) {
        GuildFeature? guildFeature = GuildFeature.get(feature);
        if (guildFeature != null) features.add(guildFeature);
      }
    }

    return Guild._(
        id: Snowflake(payload["id"]),
        name: payload["name"],
        description: payload["description"],
        ownerId: Snowflake(payload["owner_id"]),
        icon: Picture(label: payload["icon"], endpoint: "icons/${payload["id"]}/"),
        banner: Picture(label: payload["banner"], endpoint: "banners/${payload["id"]}/"),
        splash: Picture(label: payload["splash"], endpoint: "splashes/${payload["id"]}/"),
        afkChannelId: payload["afk_channel_id"] != null
            ? Snowflake(payload["afk_channel_id"])
            : null,
        afkTimeout: payload["afk_timeout"],
        rulesChannelId: payload["rules_channel_id"] != null
            ? Snowflake(payload["rules_channel_id"])
            : null,
        systemChannelId: payload["system_channel_id"] != null
            ? Snowflake(payload["system_channel_id"])
            : null,
        publicUpdatesChannelId: payload["public_updates_channel_id"] != null
            ? Snowflake(payload["public_updates_channel_id"])
            : null,
        systemChannelFlags: payload["system_channel_flags"],
        safetyAlertsChannelId: payload["safety_alerts_channel_id"] != null
            ? Snowflake(payload["safety_alerts_channel_id"])
            : null,
        widgetEnabled: payload["widget_enabled"],
        widgetChannelId: payload["widget_channel_id"] != null
            ? Snowflake(payload["widget_channel_id"])
            : null,
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
        vanity: payload['vanity_url_code'] != null
            ? Vanity(payload["vanity_url_code"], null)
            : null,
    );
  }
}