import 'package:mineral/api/common/contracts/cache_contract.dart';
import 'package:mineral/api/common/image.dart';
import 'package:mineral/api/common/resources/picture.dart';
import 'package:mineral/api/common/snowflake.dart';
import 'package:mineral/api/server/builders/guild_builder.dart';
import 'package:mineral/api/server/contracts/channels/guild_channel_contracts.dart';
import 'package:mineral/api/server/contracts/channels/guild_text_channel_contracts.dart';
import 'package:mineral/api/server/contracts/channels/guild_voice_channel_contracts.dart';
import 'package:mineral/api/server/contracts/emoji_contracts.dart';
import 'package:mineral/api/server/contracts/guild_member_contracts.dart';
import 'package:mineral/api/server/contracts/role_contracts.dart';
import 'package:mineral/api/server/resources/content_filter_level.dart';
import 'package:mineral/api/server/resources/guild_features.dart';
import 'package:mineral/api/server/resources/locale.dart';
import 'package:mineral/api/server/resources/mfa_level.dart';
import 'package:mineral/api/server/resources/notification_level.dart';
import 'package:mineral/api/server/resources/nsfw_level.dart';
import 'package:mineral/api/server/resources/premium_tier.dart';
import 'package:mineral/api/server/resources/vanity.dart';
import 'package:mineral/api/server/resources/verification_level.dart';

abstract interface class GuildContract {
  abstract final Snowflake id;
  abstract final String name;
  abstract final String? description;
  abstract final Snowflake ownerId;

  abstract final CacheContract<GuildMemberContract> members;
  abstract final CacheContract<RoleContract> roles;
  abstract final CacheContract<GuildChannelContract> channels;
  abstract final CacheContract<EmojiContract> emojis;

  abstract final Picture? icon;
  abstract final Picture? banner;
  abstract final Picture? splash;

  abstract final Snowflake? rulesChannelId;
  abstract final Snowflake? publicUpdatesChannelId;
  abstract final Snowflake? safetyAlertsChannelId;
  abstract final Snowflake? systemChannelId;
  abstract final int? systemChannelFlags;

  abstract final bool? widgetEnabled;
  abstract final Snowflake? widgetChannelId;

  abstract final VerificationLevel verificationLevel;
  abstract final NotificationLevel defaultNotificationLevel;
  abstract final ContentFilterLevel explicitContentFilter;
  abstract final NsfwLevel nsfwLevel;
  abstract final MfaLevel mfaLevel;
  abstract final PremiumTier premiumTier;
  abstract final Locale preferredLocale;
  abstract final List<GuildFeature> features;
  abstract final Vanity? vanity;

  abstract final String? applicationId;
  abstract final int? maxPresences;
  abstract final int? maxMembers;
  abstract final int? premiumSubscriptionCount;
  abstract final int? maxVideoChannelUsers;
  abstract final int? maxStageVideoChannelUsers;
  abstract final int? approximateMemberCount;
  abstract final int? approximatePresenceCount;
  abstract final bool premiumProgressBarEnabled;

  GuildTextChannelContract? get systemChannel;
  GuildTextChannelContract? get publicUpdatesChannel;
  GuildTextChannelContract? get safetyAlertsChannel;
  GuildTextChannelContract? get widgetChannel;
  GuildTextChannelContract? get rulesChannel;
  GuildVoiceChannelContract? get afkChannel;
  GuildMemberContract get owner;

  Future<void> setOwner (GuildMemberContract member, { String? reason });
  Future<void> setName(String name, { String? reason });
  Future<void> setRegion(String region, { String? reason });
  Future<void> setVerificationLevel(VerificationLevel verificationLevel, { String? reason });
  Future<void> setDefaultNotificationLevel(NotificationLevel defaultNotificationLevel, { String? reason });
  Future<void> setExplicitContentFilter(ContentFilterLevel explicitContentFilter, { String? reason });
  Future<void> setNsfwLevel(NsfwLevel nsfwLevel, { String? reason });
  Future<void> setAfkChannel(GuildVoiceChannelContract channel, { String? reason });
  Future<void> setAfkTimeout(int timeout, { String? reason });

  Future<void> setIcon(Image icon, { String? reason });
  Future<void> removeIcon({ String? reason });

  Future<void> setBanner(Image icon, { String? reason });
  Future<void> removeBanner({ String? reason });

  Future<void> setSplash(Image icon, { String? reason });
  Future<void> removeSplash({ String? reason });

  Future<void> setDiscoverySplash(Image icon, { String? reason });
  Future<void> removeDiscoverySplash({ String? reason });

  Future<void> update(GuildBuilder builder, { String? reason });
  Future<void> delete({ String? reason });

  Future<void> ban(GuildMemberContract member, { int? days, String? reason });
  Future<void> unban(Snowflake id, { String? reason });
  Future<void> kick(GuildMemberContract member, { String? reason });
  Future<void> leave({ String? reason });
}