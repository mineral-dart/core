import 'package:http/http.dart';
import 'package:mineral/api.dart';
import 'package:mineral/console.dart';
import 'package:mineral/core.dart';
import 'package:mineral/exception.dart';
import 'package:mineral/helper.dart';
import 'package:mineral/src/api/managers/channel_manager.dart';
import 'package:mineral/src/api/managers/emoji_manager.dart';
import 'package:mineral/src/api/managers/guild_webhook_manager.dart';
import 'package:mineral/src/api/managers/member_manager.dart';
import 'package:mineral/src/api/managers/moderation_rule_manager.dart';
import 'package:mineral/src/api/managers/role_manager.dart';
import 'package:mineral/src/api/managers/sticker_manager.dart';
import 'package:mineral/src/api/managers/webhook_manager.dart';
import 'package:mineral/src/api/sticker.dart';
import 'package:mineral/src/api/welcome_screen.dart';

class Guild {
  Snowflake id;
  String name;
  String? icon;
  String? iconHash;
  String? splash;
  String? discoverySplash;
  GuildMember owner;
  Snowflake ownerId;
  int? permissions;
  Snowflake? afkChannelId;
  late VoiceChannel? afkChannel;
  int afkTimeout;
  bool widgetEnabled;
  Snowflake? widgetChannelId;
  int verificationLevel;
  int defaultMessageNotifications;
  int explicitContentFilter;
  RoleManager roles;
  List<GuildFeature> features;
  int mfaLevel;
  Snowflake? applicationId;
  Snowflake? systemChannelId;
  late TextChannel? systemChannel;
  int systemChannelFlags;
  Snowflake? rulesChannelId;
  late TextChannel? rulesChannel;
  int? maxPresences;
  int maxMembers;
  String? vanityUrlCode;
  String? description;
  String? banner;
  int premiumTier;
  int premiumSubscriptionCount;
  String preferredLocale;
  Snowflake? publicUpdatesChannelId;
  late TextChannel? publicUpdatesChannel;
  int maxVideoChannelUsers;
  int? approximateMemberCount;
  int? approximatePresenceCount;
  WelcomeScreen? welcomeScreen;
  int nsfwLevel;
  StickerManager stickers;
  bool premiumProgressBarEnabled;
  MemberManager members;
  ChannelManager channels;
  EmojiManager emojis;
  ModerationRuleManager moderationRules;
  GuildWebhookManager webhooks;

  Guild({
    required this.id,
    required this.name,
    required this.icon,
    required this.iconHash,
    required this.splash,
    required this.discoverySplash,
    required this.owner,
    required this.ownerId,
    required this.permissions,
    required this.afkChannelId,
    required this.afkTimeout,
    required this.widgetEnabled,
    required this.widgetChannelId,
    required this.verificationLevel,
    required this.defaultMessageNotifications,
    required this.explicitContentFilter,
    required this.roles,
    required this.mfaLevel,
    required this.applicationId,
    required this.systemChannelId,
    required this.systemChannelFlags,
    required this.rulesChannelId,
    required this.maxPresences,
    required this.maxMembers,
    required this.vanityUrlCode,
    required this.description,
    required this.banner,
    required this.premiumTier,
    required this.premiumSubscriptionCount,
    required this.preferredLocale,
    required this.publicUpdatesChannelId,
    required this.maxVideoChannelUsers,
    required this.approximateMemberCount,
    required this.approximatePresenceCount,
    required this.welcomeScreen,
    required this.nsfwLevel,
    required this.stickers,
    required this.premiumProgressBarEnabled,
    required this.members,
    required this.channels,
    required this.emojis,
    required this.features,
    required this.moderationRules,
    required this.webhooks,
  });

  /// Modifies the [name] of the role.
  /// ```dart
  /// await guild.setName('Guild name');
  /// ```
  Future<void> setName (String name) async {
    Http http = ioc.singleton(ioc.services.http);
    Response response = await http.patch(url: "/guilds/$id", payload: { 'name': name });

    if (response.statusCode == 200) {
      this.name = name;
    }
  }

  Future<void> setVerificationLevel (int level) async {
    Http http = ioc.singleton(ioc.services.http);
    Response response = await http.patch(url: "/guilds/$id", payload: { 'verification_level': level });

    if (response.statusCode == 200) {
      verificationLevel = level;
    }
  }

  Future<Guild> setMessageNotification (int level) async {
    Http http = ioc.singleton(ioc.services.http);
    Response response = await http.patch(url: "/guilds/$id", payload: { 'default_message_notifications': level });

    if (response.statusCode == 200) {
      defaultMessageNotifications = level;
    }

    return this;
  }

  Future<void> setExplicitContentFilter (int level) async {
    Http http = ioc.singleton(ioc.services.http);
    Response response = await http.patch(url: "/guilds/$id", payload: { 'explicit_content_filter': level });

    if (response.statusCode == 200) {
      explicitContentFilter = level;
    }
  }

  Future<void> setAfkChannel (VoiceChannel channel) async {
    Http http = ioc.singleton(ioc.services.http);
    Response response = await http.patch(url: "/guilds/$id", payload: { 'afk_channel_id': channel.id });

    if (response.statusCode == 200) {
      afkChannel = channel;
      afkChannelId = channel.id;
    }
  }

  Future<void> setOwner (GuildMember guildMember) async {
    MineralClient client = ioc.singleton(ioc.services.client);
    Http http = ioc.singleton(ioc.services.http);

    if (ownerId != client.user.id) {
      Console.error(message: "You cannot change the owner of the server because it does not belong to the ${client.user.username} client.");
      return;
    }

    Response response = await http.patch(url: "/guilds/$id", payload: { 'owner_id': guildMember.user.id });

    if (response.statusCode == 200) {
      owner = guildMember;
      ownerId = guildMember.user.id;
    }
  }

  Future<void> setSplash (String filename) async {
    if (!features.contains(GuildFeature.banner)) {
      throw MissingFeatureException(cause: "The $name guild does not have the ${GuildFeature.inviteSplash} feature.");
    }

    String file = await Helper.getPicture(filename);

    Http http = ioc.singleton(ioc.services.http);
    Response response = await http.patch(url: "/guilds/$id", payload: { 'splash': file });

    if (response.statusCode == 200) {
      splash = file;
    }
  }

  Future<void> removeSplash () async {
    if (!features.contains(GuildFeature.banner)) {
      throw MissingFeatureException(cause: "The $name guild does not have the ${GuildFeature.inviteSplash} feature.");
    }

    Http http = ioc.singleton(ioc.services.http);
    Response response = await http.patch(url: "/guilds/$id", payload: { 'splash': null });

    if (response.statusCode == 200) {
      splash = null;
    }
  }

  Future<void> setDiscoverySplash (String filename) async {
    if (!features.contains(GuildFeature.banner)) {
      throw MissingFeatureException(cause: "The $name guild does not have the ${GuildFeature.discoverable} feature.");
    }

    String file = await Helper.getPicture(filename);

    Http http = ioc.singleton(ioc.services.http);
    Response response = await http.patch(url: "/guilds/$id", payload: { 'discovery_splash': file });

    if (response.statusCode == 200) {
      discoverySplash = file;
    }
  }

  Future<void> removeDiscoverySplash () async {
    if (!features.contains(GuildFeature.banner)) {
      throw MissingFeatureException(cause: "The $name guild does not have the ${GuildFeature.discoverable} feature.");
    }

    Http http = ioc.singleton(ioc.services.http);
    Response response = await http.patch(url: "/guilds/$id", payload: { 'discovery_splash': null });

    if (response.statusCode == 200) {
      discoverySplash = null;
    }
  }

  Future<void> setBanner (String filename) async {
    if (!features.contains(GuildFeature.banner)) {
      throw MissingFeatureException(cause: "The $name guild does not have the ${GuildFeature.banner} feature.");
    }

    String file = await Helper.getPicture(filename);

    Http http = ioc.singleton(ioc.services.http);
    Response response = await http.patch(url: "/guilds/$id", payload: { 'banner': file });

    if (response.statusCode == 200) {
      banner = file;
    }
  }

  Future<void> removeBanner () async {
    if (!features.contains(GuildFeature.banner)) {
      throw MissingFeatureException(cause: "The $name guild does not have the ${GuildFeature.banner} feature.");
    }

    Http http = ioc.singleton(ioc.services.http);
    Response response = await http.patch(url: "/guilds/$id", payload: { 'banner': null });

    if (response.statusCode == 200) {
      banner = null;
    }
  }

  Future<void> setIcon (String filename) async {
    String file = await Helper.getPicture(filename);

    Http http = ioc.singleton(ioc.services.http);
    Response response = await http.patch(url: "/guilds/$id", payload: { 'icon': file });

    if (response.statusCode == 200) {
      icon = file;
    }
  }

  Future<void> removeIcon () async {
    Http http = ioc.singleton(ioc.services.http);
    Response response = await http.patch(url: "/guilds/$id", payload: { 'icon': null });

    if (response.statusCode == 200) {
      icon = null;
    }
  }

  Future<void> setSystemChannel (TextChannel channel) async {
    Http http = ioc.singleton(ioc.services.http);
    Response response = await http.patch(url: "/guilds/$id", payload: { 'system_channel_id': channel.id });

    if (response.statusCode == 200) {
      systemChannelId = channel.id;
      systemChannel = channel;
    }
  }

  Future<void> setRulesChannel (TextChannel channel) async {
    Http http = ioc.singleton(ioc.services.http);
    Response response = await http.patch(url: "/guilds/$id", payload: { 'rules_channel_id': channel.id });

    if (response.statusCode == 200) {
      rulesChannelId = channel.id;
      rulesChannel = channel;
    }
  }

  Future<void> setPublicUpdateChannel (TextChannel channel) async {
    Http http = ioc.singleton(ioc.services.http);
    Response response = await http.patch(url: "/guilds/$id", payload: { 'public_updates_channel_id': channel.id });

    if (response.statusCode == 200) {
      publicUpdatesChannelId = channel.id;
      publicUpdatesChannel = channel;
    }
  }

  Future<void> setPreferredLocale (Locale locale) async {
    Http http = ioc.singleton(ioc.services.http);
    Response response = await http.patch(url: "/guilds/$id", payload: { 'public_updates_channel_id': locale });

    if (response.statusCode == 200) {
      preferredLocale = locale as String;
    }
  }

  factory Guild.from({
    required EmojiManager emojiManager,
    required MemberManager memberManager,
    required RoleManager roleManager,
    required ChannelManager channelManager,
    required ModerationRuleManager moderationRuleManager,
    required WebhookManager webhookManager,
    required dynamic payload
  }) {
    StickerManager stickerManager = StickerManager(guildId: payload['id']);
    for (dynamic element in payload['stickers']) {
      Sticker sticker = Sticker.from(element);
      stickerManager.cache.putIfAbsent(sticker.id, () => sticker);
    }

    List<GuildFeature> features = [];
    for (String element in payload['features']) {
      GuildFeature feature = GuildFeature.values.firstWhere((feature) => feature.value == element);
      features.add(feature);
    }

    return Guild(
      id: payload['id'],
      name: payload['name'],
      icon: payload['icon'],
      iconHash: payload['icon_hash'],
      splash: payload['splash'],
      discoverySplash: payload['discovery_splash'],
      owner: memberManager.cache.get(payload['owner_id'])!,
      ownerId: payload['owner_id'],
      permissions: payload['permissions'],
      afkChannelId: payload['afk_channel_id'],
      afkTimeout: payload['afk_timeout'],
      widgetEnabled: payload['widget_enabled'] ?? false,
      widgetChannelId: payload['widget_channel_id'],
      verificationLevel: payload['verification_level'],
      defaultMessageNotifications: payload['default_message_notifications'],
      explicitContentFilter: payload['explicit_content_filter'],
      roles: roleManager,
      features: features,
      mfaLevel: payload['mfa_level'],
      applicationId: payload['application_id'],
      systemChannelId: payload['system_channel_id'],
      systemChannelFlags: payload['system_channel_flags'],
      rulesChannelId: payload['rules_channel_id'],
      maxPresences: payload['max_presences'],
      maxMembers: payload['max_members'],
      vanityUrlCode: payload['vanity_url_code'],
      description: payload['description'],
      banner: payload['banner'],
      premiumTier: payload['premium_tier'],
      premiumSubscriptionCount: payload['premium_subscription_count'],
      preferredLocale: payload['preferred_locale'],
      publicUpdatesChannelId: payload['public_updates_channel_id'],
      maxVideoChannelUsers: payload['max_video_channel_users'],
      approximateMemberCount: payload['approximate_member_count'],
      approximatePresenceCount: payload['approximate_presence_count'],
      nsfwLevel: payload['nsfw_level'],
      stickers: stickerManager,
      premiumProgressBarEnabled: payload['premium_progress_bar_enabled'],
      members: memberManager,
      channels: channelManager,
      emojis: emojiManager,
      welcomeScreen: payload['welcome_screen'] != null ? WelcomeScreen.from(payload['welcome_screen']) : null,
      moderationRules: moderationRuleManager,
      webhooks: GuildWebhookManager.fromManager(webhookManager: webhookManager),
    );
  }
}
