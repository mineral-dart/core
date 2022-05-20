part of api;

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
  int afkTimeout;
  bool widgetEnabled;
  Snowflake? widgetChannelId;
  int verificationLevel;
  int defaultMessageNotifications;
  int explicitContentFilter;
  RoleManager roles;
  // emojis;
  // features;
  int mfaLevel;
  Snowflake? applicationId;
  Snowflake? systemChannelId;
  int systemChannelFlags;
  Snowflake? rulesChannelId;
  int? maxPresences;
  int maxMembers;
  String? vanityUrlCode;
  String? description;
  String? banner;
  int premiumTier;
  int premiumSubscriptionCount;
  String preferredLocale;
  Snowflake? publicUpdatesChannelId;
  int maxVideoChannelUsers;
  int? approximateMemberCount;
  int? approximatePresenceCount;
  // welcomeScreen;
  int nsfwLevel;
  // stickers;
  bool premiumProgressBarEnabled;
  MemberManager members;
  ChannelManager channels;
  EmojiManager emojis;

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
    // required this.emojis,
    // required this.features,
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
    // required this.welcomeScreen,
    required this.nsfwLevel,
    // required this.stickers,
    required this.premiumProgressBarEnabled,
    required this.members,
    required this.channels,
    required this.emojis,
  });

  Future<Guild> setName (String name) async {
    Http http = ioc.singleton(Service.http);
    Response response = await http.patch("/guilds/$id", { 'name': name });

    if (response.statusCode == 200) {
      this.name = name;
    }

    return this;
  }

  Future<Guild> setVerificationLevel (int level) async {
    Http http = ioc.singleton(Service.http);
    Response response = await http.patch("/guilds/$id", { 'verification_level': level });

    if (response.statusCode == 200) {
      verificationLevel = level;
    }

    return this;
  }

  Future<void> setSplash (String filename) async {
    String file = await Helper.getFile(filename);

    Http http = ioc.singleton(Service.http);
    Response response = await http.patch("/guilds/$id", { 'splash': file });

    if (response.statusCode == 200) {
      splash = file;
    }
  }

  Future<void> removeSplash () async {
    Http http = ioc.singleton(Service.http);
    Response response = await http.patch("/guilds/$id", { 'splash': null });

    if (response.statusCode == 200) {
      splash = null;
    }
  }

  Future<void> setDiscoverySplash (String filename) async {
    String file = await Helper.getFile(filename);

    Http http = ioc.singleton(Service.http);
    Response response = await http.patch("/guilds/$id", { 'discovery_splash': file });

    if (response.statusCode == 200) {
      discoverySplash = file;
    }
  }

  Future<void> removeDiscoverySplash () async {
    Http http = ioc.singleton(Service.http);
    Response response = await http.patch("/guilds/$id", { 'discovery_splash': null });

    if (response.statusCode == 200) {
      discoverySplash = null;
    }
  }

  Future<void> setBanner (String filename) async {
    String file = await Helper.getFile(filename);

    Http http = ioc.singleton(Service.http);
    Response response = await http.patch("/guilds/$id", { 'banner': file });

    if (response.statusCode == 200) {
      banner = file;
    }
  }

  Future<void> removeBanner () async {
    Http http = ioc.singleton(Service.http);
    Response response = await http.patch("/guilds/$id", { 'banner': null });

    if (response.statusCode == 200) {
      banner = null;
    }
  }

  Future<void> setIcon (String filename) async {
    String file = await Helper.getFile(filename);

    Http http = ioc.singleton(Service.http);
    Response response = await http.patch("/guilds/$id", { 'icon': file });

    if (response.statusCode == 200) {
      icon = file;
    }
  }

  Future<void> removeIcon () async {
    Http http = ioc.singleton(Service.http);
    Response response = await http.patch("/guilds/$id", { 'icon': null });

    if (response.statusCode == 200) {
      icon = null;
    }
  }

  factory Guild.from({ required EmojiManager emojiManager, required MemberManager memberManager, required RoleManager roleManager, required ChannelManager channelManager, required dynamic payload}) {
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
      // payload['features'],
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
      // payload['welcome_screen'],
      nsfwLevel: payload['nsfw_level'],
      // payload['stickers'],
      premiumProgressBarEnabled: payload['premium_progress_bar_enabled'],
      members: memberManager,
      channels: channelManager,
      emojis: emojiManager,
    );
  }
}
