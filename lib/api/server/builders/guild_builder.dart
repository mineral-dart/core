import 'package:mineral/api/common/resources/image.dart';
import 'package:mineral/api/common/snowflake.dart';
import 'package:mineral/api/server/resources/enums.dart';

class GuildBuilder {
  String? name;
  String? region;
  int? verificationLevel;
  int? defaultMessageNotifications;
  int? explicitContentFilter;
  Snowflake? afkChannelId;
  int? afkTimeout;
  Image? icon;
  Image? splash;
  Snowflake? systemChannelId;
  Snowflake? systemChannelFlags;
  Snowflake? rulesChannelId;
  Snowflake? publicUpdatesChannelId;
  Locale? preferredLocale;
  NsfwLevel? nsfwLevel;

  GuildBuilder();

  GuildBuilder setName(String name) {
    this.name = name;
    return this;
  }

  GuildBuilder setRegion(String region) {
    this.region = region;
    return this;
  }

  GuildBuilder setVerificationLevel(VerificationLevel verificationLevel) {
    this.verificationLevel = verificationLevel.value;
    return this;
  }

  GuildBuilder setDefaultMessageNotifications(NotificationLevel defaultMessageNotifications) {
    this.defaultMessageNotifications = defaultMessageNotifications.value;
    return this;
  }

  GuildBuilder setExplicitContentFilter(ContentFilterLevel explicitContentFilter) {
    this.explicitContentFilter = explicitContentFilter.value;
    return this;
  }

  GuildBuilder setAfkChannelId(Snowflake afkChannelId) {
    this.afkChannelId = afkChannelId;
    return this;
  }

  GuildBuilder setAfkTimeout(int afkTimeout) {
    this.afkTimeout = afkTimeout;
    return this;
  }

  GuildBuilder setIcon(Image icon) {
    this.icon = icon;
    return this;
  }

  GuildBuilder setSplash(Image splash) {
    this.splash = splash;
    return this;
  }

  GuildBuilder setSystemChannelId(Snowflake systemChannelId) {
    this.systemChannelId = systemChannelId;
    return this;
  }

  GuildBuilder setSystemChannelFlags(Snowflake systemChannelFlags) {
    this.systemChannelFlags = systemChannelFlags;
    return this;
  }

  GuildBuilder setRulesChannelId(Snowflake rulesChannelId) {
    this.rulesChannelId = rulesChannelId;
    return this;
  }

  GuildBuilder setPublicUpdatesChannelId(Snowflake publicUpdatesChannelId) {
    this.publicUpdatesChannelId = publicUpdatesChannelId;
    return this;
  }

  GuildBuilder setPreferredLocale(Locale preferredLocale) {
    this.preferredLocale = preferredLocale;
    return this;
  }

  GuildBuilder setNsfwLevel(NsfwLevel nsfwLevel) {
    this.nsfwLevel = nsfwLevel;
    return this;
  }

  Map<String, dynamic> build() {
    return {
      'name': name,
      'region': region,
      'verification_level': verificationLevel,
      'default_message_notifications': defaultMessageNotifications,
      'explicit_content_filter': explicitContentFilter,
      'afk_channel_id': afkChannelId,
      'afk_timeout': afkTimeout,
      'icon': icon,
      'splash': splash,
      'system_channel_id': systemChannelId,
      'system_channel_flags': systemChannelFlags,
      'rules_channel_id': rulesChannelId,
      'public_updates_channel_id': publicUpdatesChannelId,
      'preferred_locale': preferredLocale,
    };
  }
}