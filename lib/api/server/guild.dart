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
import 'package:mineral/api/server/guild_assets.dart';
import 'package:mineral/api/server/guild_member.dart';
import 'package:mineral/api/server/role.dart';
import 'package:mineral/domains/shared/utils.dart';

final class Guild {
  final String id;
  final String name;
  final String? description;
  final GuildMember owner;
  final GuildMemberCollection members;
  final GuildMemberCollection bots;
  final String? bitfieldPermission;
  final int? afkTimeout;
  final bool hasWidgetEnabled;
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
  final List<SystemChannelFlag> systemChannelFlags;
  final int maxMembers;
  final String? vanityUrlCode;
  final GuildAsset assets;
  final int premiumTier;
  final int? premiumSubscriptionCount;
  final String preferredLocale;
  final int? maxVideoChannelUsers;
  final int? approximateMemberCount;
  final int? approximatePresenceCount;
  final int nsfwLevel;
  final bool premiumProgressBarEnabled;

  Guild({
    required this.id,
    required this.name,
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
    required this.afkTimeout,
    required this.verificationLevel,
    required this.applicationId,
    required this.systemChannelFlags,
    required this.vanityUrlCode,
    required this.assets,
    required this.premiumSubscriptionCount,
    required this.maxVideoChannelUsers,
    required this.approximateMemberCount,
    required this.approximatePresenceCount,
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

    final channels = GuildChannelCollection.fromJson(guildId: json['id'], json: json);

    return Guild(
        id: json['id'],
        name: json['name'],
        members: members,
        bots: bots,
        hasWidgetEnabled: json['widget_enabled'] ?? false,
        defaultMessageNotifications: findInEnum(DefaultMessageNotification.values, json['default_message_notifications']),
        explicitContentFilter: findInEnum(ExplicitContentFilter.values, json['explicit_content_filter']),
        roles: roles,
        emojis: emojis,
        features: List<String>.from(json['features']),
        stickers: StickerCollection.fromJson(json['stickers']),
        channels: channels,
        mfaLevel: findInEnum(MfaLevel.values, json['mfa_level']),
        maxMembers: json['max_members'],
        premiumTier: json['premium_tier'],
        preferredLocale: json['preferred_locale'],
        nsfwLevel: json['nsfw_level'],
        premiumProgressBarEnabled: json['premium_progress_bar_enabled'],
        description: json['description'],
        bitfieldPermission: json['permissions'],
        afkTimeout: json['afk_timeout'],
        verificationLevel: findInEnum(VerificationLevel.values, json['verification_level']),
        applicationId: json['application_id'],
        systemChannelFlags: bitfieldToList(SystemChannelFlag.values, json['system_channel_flags']),
        vanityUrlCode: json['vanity_url_code'],
        assets: GuildAsset.fromJson(json),
        premiumSubscriptionCount: json['premium_subscription_count'],
        maxVideoChannelUsers: json['max_video_channel_users'],
        approximateMemberCount: json['approximate_member_count'],
        approximatePresenceCount: json['approximate_presence_count'],
        owner: members.getOrFail(json['owner_id']));
  }
}
