import 'package:mineral/api/common/resources/image.dart';
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
  final String label;

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
  final Image? icon;

  @override
  final Image? banner;

  @override
  final Image? splash;

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
  Future<void> delete() {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  Future<void> setAfkChannel({ required GuildVoiceChannelContract channel}) async {
    GuildBuilder builder = GuildBuilder();
    await update(builder.setAfkChannelId(channel.id));
  }

  @override
  Future<void> setAfkTimeout({required int timeout}) async {
    GuildBuilder builder = GuildBuilder();
    await update(builder.setAfkTimeout(timeout));
  }

  @override
  Future<void> setDefaultNotificationLevel({required NotificationLevel defaultNotificationLevel}) async {
    GuildBuilder builder = GuildBuilder();
    await update(builder.setDefaultMessageNotifications(defaultNotificationLevel));
  }

  @override
  Future<void> setExplicitContentFilter({required ContentFilterLevel explicitContentFilter}) async {
    GuildBuilder builder = GuildBuilder();
    await update(builder.setExplicitContentFilter(explicitContentFilter));
  }

  @override
  Future<void> setIcon({required Image icon}) async {
    GuildBuilder builder = GuildBuilder();
    await update(builder.setIcon(icon));
  }

  @override
  Future<void> setName({required String name}) async {
    GuildBuilder builder = GuildBuilder();
    await update(builder.setName(name));
  }

  @override
  Future<void> setNsfwLevel({required NsfwLevel nsfwLevel}) async {
    GuildBuilder builder = GuildBuilder();
    await update(builder.setNsfwLevel(nsfwLevel));
  }

  @override
  Future<void> setRegion({required String region}) async {
    GuildBuilder builder = GuildBuilder();
    await update(builder.setRegion(region));
  }

  @override
  Future<void> setVerificationLevel({required VerificationLevel verificationLevel}) async {
    GuildBuilder builder = GuildBuilder();
    await update(builder.setVerificationLevel(verificationLevel));
  }

  @override
  Future<void> update(GuildBuilder builder) async {
  /*  final http = DiscordHttpClient.singleton();

    builder.setName("Mineral test");
    final request = http
        .patch("/guilds/${id.value}")
        .payload({
          "name": "Mineral test",
        })
        .build();

    final result = await Either.future(
        future: request,
        onError: (error) => switch(error) {
          HttpError(statusCode: final code) when code == 400 => throw Exception("HttpError: $code"),
        // TODO: Handle this case.
          HttpError(statusCode: final code, message: final message) => throw Exception("HttpError ($code): $message"),
        },
        onSuccess: (response) => response,
    );

    print(result.statusCode);
    print(result.body['name']);*/
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
        id: Snowflake(payload["id"]),
        label: payload["name"],
        description: payload["description"],
        ownerId: Snowflake(payload["owner_id"]),
        icon: Image(label: payload["icon"], endpoint: "icons/${payload["id"]}/"),
        banner: Image(label: payload["banner"], endpoint: "banners/${payload["id"]}/"),
        splash: Image(label: payload["splash"], endpoint: "splashes/${payload["id"]}/"),
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