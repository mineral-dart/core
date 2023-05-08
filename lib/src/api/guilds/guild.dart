import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:http/http.dart';
import 'package:mineral/core.dart';
import 'package:mineral/core/api.dart';
import 'package:mineral/core/builders.dart';
import 'package:mineral/exception.dart';
import 'package:mineral/framework.dart';
import 'package:mineral/src/api/managers/channel_manager.dart';
import 'package:mineral/src/api/managers/command_manager.dart';
import 'package:mineral/src/api/managers/emoji_manager.dart';
import 'package:mineral/src/api/managers/guild_invite_manager.dart';
import 'package:mineral/src/api/managers/guild_role_manager.dart';
import 'package:mineral/src/api/managers/guild_scheduled_event_manager.dart';
import 'package:mineral/src/api/managers/guild_webhook_manager.dart';
import 'package:mineral/src/api/managers/member_manager.dart';
import 'package:mineral/src/api/managers/moderation_rule_manager.dart';
import 'package:mineral/src/api/managers/sticker_manager.dart';
import 'package:mineral/src/api/managers/webhook_manager.dart';
import 'package:mineral/src/api/welcome_screen.dart';
import 'package:mineral/src/helper.dart';
import 'package:mineral/src/internal/services/console/console_service.dart';
import 'package:mineral_ioc/ioc.dart';

class SourceGuild {
  final Snowflake _id;
  final String _label;
  final ImageFormater _icon;

  SourceGuild(this._id, this._label, this._icon);

  Snowflake get id => _id;
  String get label => _label;
  ImageFormater? get icon => _icon;
}

/// Represent Discord serveur as Class.
class Guild {
  Snowflake _id;
  String _name;
  Snowflake _ownerId;
  ImageFormater? _icon;
  String? _iconHash;
  ImageFormater? _splash;
  ImageFormater? _discoverySplash;
  int? _permissions;
  Snowflake? _afkChannelId;
  late VoiceChannel? afkChannel;
  int _afkTimeout;
  bool _widgetEnabled;
  Snowflake? _widgetChannelId;
  VerificationLevel _verificationLevel;
  int _defaultMessageNotifications;
  int _explicitContentFilter;
  GuildRoleManager _roles;
  List<GuildFeature> _features;
  int _mfaLevel;
  Snowflake? _applicationId;
  Snowflake? _systemChannelId;
  late TextChannel? systemChannel;
  int _systemChannelFlags;
  Snowflake? _rulesChannelId;
  late TextChannel? rulesChannel;
  int? _maxPresences;
  int _maxMembers;
  String? _vanityUrlCode;
  String? _description;
  ImageFormater? _banner;
  int _premiumTier;
  int _premiumSubscriptionCount;
  String _preferredLocale;
  Snowflake? _publicUpdatesChannelId;
  late TextChannel? publicUpdatesChannel;
  int _maxVideoChannelUsers;
  int? _approximateMemberCount;
  int? _approximatePresenceCount;
  WelcomeScreen? _welcomeScreen;
  int _nsfwLevel;
  StickerManager _stickers;
  bool _premiumProgressBarEnabled;
  MemberManager _members;
  ChannelManager _channels;
  EmojiManager _emojis;
  ModerationRuleManager _moderationRules;
  GuildWebhookManager _webhooks;
  GuildScheduledEventService _scheduledEvents;
  CommandService _commands;
  GuildInviteManager _invites;

  Guild(
    this._id,
    this._name,
    this._ownerId,
    this._icon,
    this._iconHash,
    this._splash,
    this._discoverySplash,
    this._permissions,
    this._afkChannelId,
    this._afkTimeout,
    this._widgetEnabled,
    this._widgetChannelId,
    this._verificationLevel,
    this._defaultMessageNotifications,
    this._explicitContentFilter,
    this._roles,
    this._mfaLevel,
    this._applicationId,
    this._systemChannelId,
    this._systemChannelFlags,
    this._rulesChannelId,
    this._maxPresences,
    this._maxMembers,
    this._vanityUrlCode,
    this._description,
    this._banner,
    this._premiumTier,
    this._premiumSubscriptionCount,
    this._preferredLocale,
    this._publicUpdatesChannelId,
    this._maxVideoChannelUsers,
    this._approximateMemberCount,
    this._approximatePresenceCount,
    this._welcomeScreen,
    this._nsfwLevel,
    this._stickers,
    this._premiumProgressBarEnabled,
    this._members,
    this._channels,
    this._emojis,
    this._features,
    this._moderationRules,
    this._webhooks,
    this._scheduledEvents,
    this._commands,
    this._invites,
  );

  /// The [Guild]'s id.
  Snowflake get id => _id;

  /// The [Guild]'s name.
  String get name => _name;

  /// The [Guild]'s owner.
  GuildMember get owner => members.cache.getOrFail(_ownerId);

  /// The [Guild]'s icon.
  ImageFormater? get icon => _icon;

  /// The [Guild]'s icon hash.
  String? get iconHash => _iconHash;

  /// The [Guild]'s splash.
  ImageFormater? get splash => _splash;

  /// The [Guild]'s discovery splash.
  ImageFormater? get discoverySplash => _discoverySplash;

  /// The [Guild]'s permissions.
  int? get permissions => _permissions;

  /// The [Guild]'s afk channel.
  Snowflake? get afkChannelId => _afkChannelId;

  /// The [Guild]'s afk timeout.
  int get afkTimeout => _afkTimeout;

  /// The [Guild]'s widget enabled.
  bool get widgetEnabled => _widgetEnabled;

  /// The [Guild]'s widget channel.
  Snowflake? get widgetChannelId => _widgetChannelId;

  /// The [Guild]'s verification level.
  VerificationLevel get verificationLevel => _verificationLevel;

  /// The [Guild]'s default message notifications.
  NotificationLevel get defaultMessageNotifications => NotificationLevel.values.firstWhere((element) => element.value == _defaultMessageNotifications);

  /// The [Guild]'s explicit content filter.
  ExplicitContentLevel get explicitContentFilter => ExplicitContentLevel.values.firstWhere((element) => element.value == _explicitContentFilter);

  /// The [Guild]'s roles.
  GuildRoleManager get roles => _roles;

  /// The [Guild]'s features.
  List<GuildFeature> get features => _features;

  /// The [Guild]'s mfa level.
  int get mfaLevel => _mfaLevel;

  /// The [Guild]'s application id.
  Snowflake? get applicationId => _applicationId;

  /// The [Guild]'s system channel id.
  Snowflake? get systemChannelId => _systemChannelId;

  /// The [Guild]'s system channel.
  int get systemChannelFlags => _systemChannelFlags;

  /// The [Guild]'s rules channel id.
  Snowflake? get rulesChannelId => _rulesChannelId;

  /// The [Guild]'s max presences.
  int? get maxPresences => _maxPresences;

  /// The [Guild]'s max members.
  int get maxMembers => _maxMembers;


  /// The [Guild]'s vanity url code.
  String? get vanityUrlCode => _vanityUrlCode;

  /// The [Guild]'s description.
  String? get description => _description;

  /// The [Guild]'s banner.
  ImageFormater? get banner => _banner;

  /// The [Guild]'s premium tier.
  int get premiumTier => _premiumTier;

  /// The [Guild]'s premium subscription count.
  int get premiumSubscriptionCount => _premiumSubscriptionCount;

  /// The [Guild]'s preferred locale.
  Locale get preferredLocale => Locale.values.firstWhere((lang) => lang.locale == _preferredLocale);

  /// The [Guild]'s public updates channel id.
  Snowflake? get publicUpdatesChannelId => _publicUpdatesChannelId;

  /// The [Guild]'s max video channel users.
  int get maxVideoChannelUsers => _maxVideoChannelUsers;

  /// The [Guild]'s approximate member count.
  int? get approximateMemberCount => _approximateMemberCount;

  /// The [Guild]'s approximate presence count.
  int? get approximatePresenceCount => _approximatePresenceCount;

  /// The [Guild]'s welcome screen.
  WelcomeScreen? get welcomeScreen => _welcomeScreen;

  /// The [Guild]'s nsfw level.
  int get nsfwLevel => _nsfwLevel;

  /// The [Guild]'s stickers.
  StickerManager get stickers => _stickers;

  /// The [Guild]'s premium progress bar enabled.
  bool get premiumProgressBarEnabled => _premiumProgressBarEnabled;

  /// The [Guild]'s members manager.
  MemberManager get members => _members;

  /// The [Guild]'s channels manager.
  ChannelManager get channels => _channels;

  /// The [Guild]'s emojis manager.
  EmojiManager get emojis => _emojis;

  /// The [Guild]'s moderation rules manager.
  ModerationRuleManager get moderationRules => _moderationRules;

  /// The [Guild]'s webhooks manager.
  GuildWebhookManager get webhooks => _webhooks;

  /// The [Guild]'s scheduled events manager.
  GuildScheduledEventService get scheduledEvents => _scheduledEvents;

  /// The [Guild]'s bot members.
  Map<Snowflake, GuildMember> get bots => _members.cache.where((element) => element.isBot);

  /// The [Guild]'s commands manager.
  CommandService get commands => _commands;

  /// The [Guild]'s invites manager.
  GuildInviteManager get invites => _invites;

  /// Used to update the name of this
  ///
  /// ```dart
  /// await guild.setName('Guild name');
  /// ```
  Future<void> setName (String name) async {
    Response response = await ioc.use<DiscordApiHttpService>().patch(url: "/guilds/$id")
      .payload({ 'name': name })
      .build();

    if (response.statusCode == 200) {
      _name = name;
    }
  }

  /// Modifies the [VerificationLevel] of this.
  ///
  /// ```dart
  /// await guild.setVerificationLevel(VerificationLevel.veryHigh);
  /// ```
  Future<void> setVerificationLevel (VerificationLevel level) async {
    Response response = await ioc.use<DiscordApiHttpService>().patch(url: "/guilds/$id")
      .payload({ 'verification_level': level.value })
      .build();

    if (response.statusCode == 200) {
      _verificationLevel = level;
    }
  }

  /// Defines the notification level of this
  /// ```dart
  /// await guild.setMessageNotification(NotificationLevel.onlyMentions);
  /// ```
  Future<void> setMessageNotification (NotificationLevel level) async {
    Response response = await ioc.use<DiscordApiHttpService>().patch(url: "/guilds/$id")
      .payload({ 'default_message_notifications': level.value })
      .build();

    if (response.statusCode == 200) {
      _defaultMessageNotifications = level.value;
    }
  }

  /// Defines the explicit content level of this
  /// ```dart
  /// await guild.setExplicitContentFilter(2);
  /// ```
  Future<void> setExplicitContentFilter (ExplicitContentLevel level) async {
    Response response = await ioc.use<DiscordApiHttpService>().patch(url: "/guilds/$id")
      .payload({ 'explicit_content_filter': level.value })
      .build();

    if (response.statusCode == 200) {
      _explicitContentFilter = level.value;
    }
  }

  /// Update the afk channel
  ///
  /// ```dart
  /// final voiceChannel = guild.channels.cache.getOrFail('240561194958716924');
  /// await guild.setAfkChannel(2);
  /// ```
  Future<void> setAfkChannel (VoiceChannel channel) async {
    Response response = await ioc.use<DiscordApiHttpService>().patch(url: "/guilds/$id")
      .payload({ 'afk_channel_id': channel.id })
      .build();

    if (response.statusCode == 200) {
      _afkChannelId = channel.id;
    }
  }

  /// Update the owner of this
  ///
  /// Warning : This method only works if the server was created via a discord bot and the bot is the current owner,
  /// see [documentation](https://discord.com/developers/docs/resources/guild#modify-guild).
  /// ```dart
  /// final member = guild.members.cache.getOrFail('240561194958716924');
  /// await guild.setOwner(member);
  /// ```
  Future<void> setOwner (GuildMember guildMember) async {
    MineralClient client = ioc.use<MineralClient>();

    if (owner.id != client.user.id) {
      ioc.use<ConsoleService>().error("You cannot change the owner of the server because it does not belong to the ${client.user.username} client.");
      return;
    }

    Response response = await ioc.use<DiscordApiHttpService>().patch(url: "/guilds/$id")
      .payload({ 'owner_id': guildMember.user.id })
      .build();

    if (response.statusCode == 200) {
      _ownerId = guildMember.id;
    }
  }

  /// Update the splash banner of this
  ///
  /// This method requires the feature [GuildFeature.banner] of this.
  /// ```dart
  /// await guild.setSplash('assets/images/my_splash_banner.png');
  /// ```
  Future<void> setSplash (String filename) async {
    if (!features.contains(GuildFeature.banner)) {
      throw MissingFeatureException('The $name guild does not have the ${GuildFeature.inviteSplash} feature.');
    }

    String file = await Helper.getPicture(filename);

    Response response = await ioc.use<DiscordApiHttpService>().patch(url: "/guilds/$id")
      .payload({ 'splash': file })
      .build();

    if (response.statusCode == 200) {
      _splash = ImageFormater(file, '');
    }
  }

  /// Remove the splash banner of this
  ///
  /// This method requires the feature [GuildFeature.banner] of this.
  /// ```dart
  /// await guild.removeSplash();
  /// ```
  Future<void> removeSplash () async {
    if (!features.contains(GuildFeature.banner)) {
      throw MissingFeatureException('The $name guild does not have the ${GuildFeature.inviteSplash} feature.');
    }

    Response response = await ioc.use<DiscordApiHttpService>().patch(url: "/guilds/$id")
      .payload({ 'splash': null })
      .build();

    if (response.statusCode == 200) {
      _splash = null;
    }
  }

  /// Update the discovery splash banner of this
  ///
  /// This method requires the feature [GuildFeature.banner] of this.
  /// ```dart
  /// await guild.setDiscoverySplash('assets/images/my_splash_discovery_banner.png');
  /// ```
  Future<void> setDiscoverySplash (String filename) async {
    if (!features.contains(GuildFeature.banner)) {
      throw MissingFeatureException('The $name guild does not have the ${GuildFeature.discoverable} feature.');
    }

    String file = await Helper.getPicture(filename);

    Response response = await ioc.use<DiscordApiHttpService>().patch(url: "/guilds/$id")
      .payload({ 'discovery_splash': file })
      .build();

    if (response.statusCode == 200) {
      _discoverySplash = ImageFormater(file, '');
    }
  }

  /// Remove the discovery splash banner of this
  ///
  /// This method requires the feature [GuildFeature.banner] of this.
  /// ```dart
  /// await guild.removeDiscoverySplash();
  /// ```
  Future<void> removeDiscoverySplash () async {
    if (!features.contains(GuildFeature.banner)) {
      throw MissingFeatureException('The $name guild does not have the ${GuildFeature.discoverable} feature.');
    }

    Response response = await ioc.use<DiscordApiHttpService>().patch(url: "/guilds/$id")
      .payload({ 'discovery_splash': null })
      .build();

    if (response.statusCode == 200) {
      _discoverySplash = null;
    }
  }

  /// Update the banner of this
  ///
  /// This method requires the feature [GuildFeature.banner] of this.
  /// ```dart
  /// await guild.setBanner('assets/images/my_banner.png');
  /// ```
  Future<void> setBanner (String filename) async {
    if (!features.contains(GuildFeature.banner)) {
      throw MissingFeatureException('The $name guild does not have the ${GuildFeature.banner} feature.');
    }

    String file = await Helper.getPicture(filename);

    Response response = await ioc.use<DiscordApiHttpService>().patch(url: "/guilds/$id")
      .payload({ 'banner': file })
      .build();

    if (response.statusCode == 200) {
      _banner = ImageFormater(file, '');
    }
  }

  /// Remove the banner of this
  ///
  /// This method requires the feature [GuildFeature.banner] of this.
  /// ```dart
  /// await guild.removeBanner();
  /// ```
  Future<void> removeBanner () async {
    if (!features.contains(GuildFeature.banner)) {
      throw MissingFeatureException('The $name guild does not have the ${GuildFeature.banner} feature.');
    }

    Response response = await ioc.use<DiscordApiHttpService>().patch(url: "/guilds/$id")
      .payload({ 'banner': null })
      .build();

    if (response.statusCode == 200) {
      _banner = null;
    }
  }

  /// Update the icon of this.
  ///
  /// ```dart
  /// await guild.setIcon('assets/images/my_guild_icon.png');
  /// ```
  Future<void> setIcon (String filename) async {
    String file = await Helper.getPicture(filename);

    Response response = await ioc.use<DiscordApiHttpService>().patch(url: "/guilds/$id")
      .payload({ 'icon': file })
      .build();

    if (response.statusCode == 200) {
      _icon = ImageFormater(file, '');
    }
  }

  /// Remove the icon of this

  /// ```dart
  /// await guild.removeIcon();
  /// ```
  Future<void> removeIcon () async {
    Response response = await ioc.use<DiscordApiHttpService>().patch(url: "/guilds/$id")
      .payload({ 'icon': null })
      .build();

    if (response.statusCode == 200) {
      _icon = null;
    }
  }

  /// Update system channel of this
  ///
  /// ```dart
  /// final channel = guild.channels.cache.getOrFail('240561194958716924');
  /// await guild.setSystemChannel(channel);
  /// ```
  Future<void> setSystemChannel (TextChannel channel) async {
    Response response = await ioc.use<DiscordApiHttpService>().patch(url: "/guilds/$id")
      .payload({ 'system_channel_id': channel.id })
      .build();

    if (response.statusCode == 200) {
      _systemChannelId = channel.id;
      systemChannel = channel;
    }
  }

  /// Update rules channel of this
  ///
  /// ```dart
  /// final channel = guild.channels.cache.getOrFail('240561194958716924');
  /// await guild.setRulesChannel(channel);
  /// ```
  Future<void> setRulesChannel (TextChannel channel) async {
    Response response = await ioc.use<DiscordApiHttpService>().patch(url: "/guilds/$id")
      .payload({ 'rules_channel_id': channel.id })
      .build();

    if (response.statusCode == 200) {
      _rulesChannelId = channel.id;
      rulesChannel = channel;
    }
  }

  /// Update public updates channel of this
  ///
  /// ```dart
  /// final channel = guild.channels.cache.getOrFail('240561194958716924');
  /// await guild.setPublicUpdateChannel(channel);
  /// ```
  Future<void> setPublicUpdateChannel (TextChannel channel) async {
    Response response = await ioc.use<DiscordApiHttpService>().patch(url: "/guilds/$id")
      .payload({ 'public_updates_channel_id': channel.id })
      .build();

    if (response.statusCode == 200) {
      _publicUpdatesChannelId = channel.id;
      publicUpdatesChannel = channel;
    }
  }

  /// Update preferred language of this
  ///
  /// ```dart
  /// await guild.setPreferredLocale(Locale.fr);
  /// ```
  Future<void> setPreferredLocale (Locale locale) async {
    Response response = await ioc.use<DiscordApiHttpService>().patch(url: "/guilds/$id")
      .payload({ 'public_updates_channel_id': locale })
      .build();

    if (response.statusCode == 200) {
      _preferredLocale = locale as String;
    }
  }

  /// Remove the discord client of this
  ///
  /// ```dart
  /// await guild.leave();
  /// ```
  Future<void> leave () async {
    Response response = await ioc.use<DiscordApiHttpService>().destroy(url: '/users/@me/guilds/$id').build();

    if (response.statusCode == 204) {
      MineralClient client = ioc.use<MineralClient>();
      client.guilds.cache.remove(this);
    }
  }

  /// Get [Guild] as [EmbedBuilder] format.
  Future<GuildPreview> preview () async {
    Response response = await ioc.use<DiscordApiHttpService>()
      .get(url: '/guilds/$id/preview')
      .build();

    return GuildPreview.from(
      guild: this,
      payload: jsonDecode(response.body)
    );
  }

  /// Unbanned this from the [Guild] and deleted its messages for a given period
  ///
  /// ```dart
  /// await member.unban();
  /// ```
  Future<bool> ban (Snowflake memberId, { String? reason }) async {
    Response response = await ioc.use<DiscordApiHttpService>().destroy(url: '/guilds/$id/bans/$memberId')
      .auditLog(reason)
      .build();

    return response.statusCode == 200;
  }

  factory Guild.from({
    required EmojiManager emojiManager,
    required MemberManager memberManager,
    required GuildRoleManager roleManager,
    required ChannelManager channelManager,
    required ModerationRuleManager moderationRuleManager,
    required WebhookManager webhookManager,
    required GuildScheduledEventService guildScheduledEventService,
    required dynamic payload
  }) {
    StickerManager stickerManager = StickerManager();

    final List<GuildFeature> features = List<GuildFeature>.from(payload['features'].map((element) {
      GuildFeature? feature = GuildFeature.values.firstWhereOrNull((feature) => feature.value == element);
      if (feature != null) {
        return feature;
      }

      ioc.use<ConsoleService>().warn('Guild feature $element don\'t exist! Please report this to our team.');
    }));

    return Guild(
      payload['id'],
      payload['name'],
      payload['owner_id'],
      payload['icon'] != null ? ImageFormater(payload['icon'], 'icons/${payload['id']}') : null,
      payload['icon_hash'],
      payload['splash'] != null ? ImageFormater(payload['splash'], 'splashes/${payload['id']}') : null,
      payload['discovery_splash'] != null ? ImageFormater(payload['discovery_splash'], 'discovery-splashes/${payload['id']}') : null,
      payload['permissions'],
      payload['afk_channel_id'],
      payload['afk_timeout'],
      payload['widget_enabled'] ?? false,
      payload['widget_channel_id'],
      VerificationLevel.values.firstWhere((level) => level.value == payload['verification_level']),
      payload['default_message_notifications'],
      payload['explicit_content_filter'],
      roleManager,
      payload['mfa_level'],
      payload['application_id'],
      payload['system_channel_id'],
      payload['system_channel_flags'],
      payload['rules_channel_id'],
      payload['max_presences'],
      payload['max_members'],
      payload['vanity_url_code'],
      payload['description'],
      payload['banner'] != null ? ImageFormater(payload['banner'], 'banners/${payload['id']}') : null,
      payload['premium_tier'],
      payload['premium_subscription_count'],
      payload['preferred_locale'],
      payload['public_updates_channel_id'],
      payload['max_video_channel_users'],
      payload['approximate_member_count'],
      payload['approximate_presence_count'],
      payload['welcome_screen'] != null ? WelcomeScreen.from(payload['welcome_screen']) : null,
      payload['nsfw_level'],
      stickerManager,
      payload['premium_progress_bar_enabled'],
      memberManager,
      channelManager,
      emojiManager,
      features,
      moderationRuleManager,
      GuildWebhookManager.fromManager(webhookManager: webhookManager),
      guildScheduledEventService,
      CommandService(payload['id']),
      GuildInviteManager(payload['id'])
    );
  }
}
