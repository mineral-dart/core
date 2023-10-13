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
  abstract final String id;
  abstract String label;
  abstract String? description;
  abstract String ownerId;

  abstract final GuildMemberCache members; // todo: member cache
  abstract final GuildRolesCache roles;
  abstract final GuildChannelsCache channels;
  abstract final GuildEmojisCache emojis;

  abstract String? rulesChannelId;
  abstract String? publicUpdatesChannelId;
  abstract String? safetyAlertsChannelId;
  abstract String? systemChannelId;
  abstract int? systemChannelFlags;

  abstract bool? widgetEnabled;
  abstract String? widgetChannelId;

  abstract VerificationLevel verificationLevel;
  abstract NotificationLevel defaultNotificationLevel;
  abstract ContentFilterLevel explicitContentFilter;
  abstract NsfwLevel nsfwLevel;
  abstract MfaLevel mfaLevel;
  abstract PremiumTier premiumTier;
  abstract Locale preferredLocale;
  abstract List<GuildFeature> features;
  abstract Vanity? vanity;

  abstract String? applicationId;
  abstract int? maxPresences;
  abstract int? maxMembers;
  abstract int? premiumSubscriptionCount;
  abstract int? maxVideoChannelUsers;
  abstract int? maxStageVideoChannelUsers;
  abstract int? approximateMemberCount;
  abstract int? approximatePresenceCount;
  abstract bool premiumProgressBarEnabled;
}