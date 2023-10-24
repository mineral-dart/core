import 'package:mineral/api/common/image.dart';
import 'package:mineral/api/common/snowflake.dart';
import 'package:mineral/api/server/resources/enums.dart';

class GuildBuilder {
  final Map<String, dynamic> _fields = {};

  GuildBuilder();

  GuildBuilder setName(String name) {
    _fields['name'] = name;
    return this;
  }

  GuildBuilder setRegion(String region) {
    _fields['region'] = region;
    return this;
  }

  GuildBuilder setVerificationLevel(VerificationLevel verificationLevel) {
    _fields['verification_level'] = verificationLevel.value;
    return this;
  }

  GuildBuilder setDefaultMessageNotifications(NotificationLevel defaultMessageNotifications) {
    _fields['default_message_notifications'] = defaultMessageNotifications.value;
    return this;
  }

  GuildBuilder setExplicitContentFilter(ContentFilterLevel explicitContentFilter) {
    _fields['explicit_content_filter'] = explicitContentFilter.value;
    return this;
  }

  GuildBuilder setAfkChannelId(Snowflake afkChannelId) {
    _fields['afk_channel_id'] = afkChannelId;
    return this;
  }

  GuildBuilder setAfkTimeout(int afkTimeout) {
    _fields['afk_timeout'] = afkTimeout;
    return this;
  }

  GuildBuilder setIcon(Image? file) {
    _fields['icon'] = file?.encode;
    return this;
  }

  GuildBuilder setSplash(Image? file) {
    _fields['splash'] = file?.encode;
    return this;
  }

  GuildBuilder setDiscoverySplash(Image? file) {
    _fields['discovery_splash'] = file?.encode;
    return this;
  }

  GuildBuilder setBanner(Image? file) {
    _fields['banner'] = file?.encode;
    return this;
  }

  GuildBuilder setSystemChannelId(Snowflake systemChannelId) {
    _fields['system_channel_id'] = systemChannelId.value;
    return this;
  }

  GuildBuilder setSystemChannelFlags(Snowflake systemChannelFlags) {
    _fields['system_channel_flags'] = systemChannelFlags.value;
    return this;
  }

  GuildBuilder setRulesChannelId(Snowflake rulesChannelId) {
    _fields['rules_channel_id'] = rulesChannelId.value;
    return this;
  }

  GuildBuilder setPublicUpdatesChannelId(Snowflake publicUpdatesChannelId) {
    _fields['public_updates_channel_id'] = publicUpdatesChannelId.value;
    return this;
  }

  GuildBuilder setPreferredLocale(Locale preferredLocale) {
    _fields['preferred_locale'] = preferredLocale.locale;
    return this;
  }

  GuildBuilder setNsfwLevel(NsfwLevel nsfwLevel) {
    _fields['nsfw_level'] = nsfwLevel.value;
    return this;
  }

  Map<String, dynamic> build() => _fields;
}