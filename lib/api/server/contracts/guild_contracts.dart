import 'package:mineral/api/common/resources/image.dart';
import 'package:mineral/api/common/snowflake.dart';
import 'package:mineral/api/server/caches/guild_channels_cache.dart';
import 'package:mineral/api/server/caches/guild_emojis_cache.dart';
import 'package:mineral/api/server/caches/guild_members_cache.dart';
import 'package:mineral/api/server/caches/guild_roles_cache.dart';
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
  abstract final String label;
  abstract final String? description;
  abstract final String ownerId;

  abstract final GuildMemberCache members;
  abstract final GuildRolesCache roles;
  abstract final GuildChannelsCache channels;
  abstract final GuildEmojisCache emojis;

  abstract final Image? icon;
  abstract final Image? banner;
  abstract final Image? splash;

  abstract final String? rulesChannelId;
  abstract final String? publicUpdatesChannelId;
  abstract final String? safetyAlertsChannelId;
  abstract final String? systemChannelId;
  abstract final int? systemChannelFlags;

  abstract final bool? widgetEnabled;
  abstract final String? widgetChannelId;

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
}