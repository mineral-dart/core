import 'dart:async';

import 'package:mineral/api.dart';
import 'package:mineral/src/api/server/managers/threads_manager.dart';
import 'package:mineral/src/domains/commons/utils/helper.dart';
import 'package:mineral/src/domains/commons/utils/utils.dart';
import 'package:mineral/src/domains/contracts/marshaller/marshaller.dart';
import 'package:mineral/src/domains/services/container/ioc_container.dart';
import 'package:mineral/src/infrastructure/internals/marshaller/types/serializer.dart';

final class ServerSerializer implements SerializerContract<Server> {
  MarshallerContract get _marshaller => ioc.resolve<MarshallerContract>();

  @override
  Future<Map<String, dynamic>> normalize(Map<String, dynamic> json) async {
    final Map<String, dynamic> serverPayload = {
      'id': json['id'],
      'name': json['name'],
      'description': json['description'],
      'application_id': json['application_id'],
      'owner_id': json['owner_id'],
      'assets': {
        'icon': json['icon'],
        'icon_hash': json['icon_hash'],
        'splash': json['splash'],
        'discovery_splash': json['discovery_splash'],
        'banner': json['banner'],
      },
      'settings': {
        'permissions': json['permissions'],
        'afk_timeout': json['afk_timeout'],
        'widget_enabled': json['widget_enabled'] ?? false,
        'explicit_content_filter': json['explicit_content_filter'],
        'verification_level': json['verification_level'],
        'default_message_notifications': json['default_message_notifications'],
        'features': List.from(json['features']),
        'mfa_level': json['mfa_level'],
        'system_channel_flags': json['system_channel_flags'],
        'vanity_url_code': json['vanity_url_code'],
        'premium_tier': json['premium_tier'],
        'premium_subscription_count': json['premium_subscription_count'],
        'premium_progress_bar_enabled': json['premium_progress_bar_enabled'],
        'preferred_locale': json['preferred_locale'],
        'max_video_channel_users': json['max_video_channel_users'],
        'nsfw_level': json['nsfw_level'],
        'subscription': {
          'tier': json['premium_tier'],
          'subscription_count': json['premium_subscription_count'],
          'has_enabled_progress_bar': json['premium_progress_bar_enabled'],
        }
      },
      'channel_settings': {
        'afk_channel_id': json['afk_channel_id'],
        'system_channel_id': json['system_channel_id'],
        'rules_channel_id': json['rules_channel_id'],
        'public_updates_channel_id': json['public_updates_channel_id'],
        'safety_alerts_channel_id': json['safety_alerts_channel_id'],
      },
    };

    final serverCacheKey = _marshaller.cacheKey.server(json['id']);
    await _marshaller.cache?.put(serverCacheKey, serverPayload);

    return serverPayload;
  }

  @override
  Future<Server> serialize(Map<String, dynamic> payload) async {
    final channelManager = ChannelManager.fromMap(payload['id'], payload['channel_settings']);
    final threadManager = ThreadsManager(Snowflake.parse(payload['id']), null);
    final roleManager = RoleManager(Snowflake.parse(payload['id']));
    final memberManager = MemberManager(Snowflake.parse(payload['id']));

    final serverAssets = ServerAsset(
      Snowflake.parse(payload['id']),
      emojis: EmojiManager(Snowflake.parse(payload['id'])),
      stickers: StickerManager(Snowflake.parse(payload['id'])),
      icon: Helper.createOrNull(
          field: payload['icon'],
          fn: () => ImageAsset(['icons', payload['server_id']], payload['icon'])),
      splash: Helper.createOrNull(
          field: payload['splash'],
          fn: () => ImageAsset(['splashes', payload['server_id']], payload['splash'])),
      banner: Helper.createOrNull(
          field: payload['banner'],
          fn: () => ImageAsset(['banners', payload['server_id']], payload['banner'])),
      discoverySplash: Helper.createOrNull(
          field: payload['discovery_splash'],
          fn: () => ImageAsset(['discovery-splashes', payload['id']], payload['discovery_splash'])),
    );


    final serverSettings = ServerSettings(
        bitfieldPermission: payload['permissions'],
        afkTimeout: payload['afk_timeout'],
        hasWidgetEnabled: payload['widget_enabled'] ?? false,
        explicitContentFilter:
            findInEnum(ExplicitContentFilter.values, payload['settings']['explicit_content_filter']),
        verificationLevel: findInEnum(VerificationLevel.values, payload['settings']['verification_level']),
        defaultMessageNotifications:
            findInEnum(DefaultMessageNotification.values, payload['settings']['default_message_notifications']),
        features: List<String>.from(payload['settings']['features']),
        mfaLevel: findInEnum(MfaLevel.values, payload['settings']['mfa_level']),
        systemChannelFlags:
            bitfieldToList(SystemChannelFlag.values, payload['settings']['system_channel_flags']),
        vanityUrlCode: payload['vanity_url_code'],
        subscription: ServerSubscription(
          tier: findInEnum(PremiumTier.values, payload['settings']['premium_tier']),
          subscriptionCount: payload['settings']['premium_subscription_count'],
          hasEnabledProgressBar: payload['settings']['premium_progress_bar_enabled'],
        ),
        preferredLocale: payload['settings']['preferred_locale'],
        maxVideoChannelUsers: payload['max_video_channel_users'],
        nsfwLevel: findInEnum(NsfwLevel.values, payload['settings']['nsfw_level']));

    return Server(
      id: Snowflake.parse(payload['id']),
      name: payload['name'],
      description: payload['description'],
      applicationId: payload['application_id'],
      members: memberManager,
      settings: serverSettings,
      roles: roleManager,
      channels: channelManager,
      assets: serverAssets,
      threads: threadManager,
      ownerId: Snowflake.parse(payload['owner_id']),
    );
  }

  @override
  Future<Map<String, dynamic>> deserialize(Server server) async {
    return {
      'id': server.id,
      'name': server.name,
      'description': server.description,
      'application_id': server.applicationId,
      'owner_id': server.ownerId,
      'assets': {
        'icon': server.assets.icon?.hash,
        'splash': server.assets.splash?.hash,
        'banner': server.assets.banner?.hash,
        'discovery_splash': server.assets.discoverySplash?.hash,
        'server_id': server.assets.serverId.value,
      },
      'settings': {
        'permissions': server.settings.bitfieldPermission,
        'afk_timeout': server.settings.afkTimeout,
        'widget_enabled': server.settings.hasWidgetEnabled,
        'explicit_content_filter': server.settings.explicitContentFilter.value,
        'verification_level': server.settings.verificationLevel.value,
        'default_message_notifications': server.settings.defaultMessageNotifications.value,
        'features': server.settings.features,
        'mfa_level': server.settings.mfaLevel.value,
        'system_channel_flags': listToBitfield(server.settings.systemChannelFlags),
        'vanity_url_code': server.settings.vanityUrlCode,
        'premium_tier': server.settings.subscription.tier.value,
        'premium_subscription_count': server.settings.subscription.subscriptionCount,
        'premium_progress_bar_enabled': server.settings.subscription.hasEnabledProgressBar,
        'preferred_locale': server.settings.preferredLocale,
        'max_video_channel_users': server.settings.maxVideoChannelUsers,
        'nsfw_level': server.settings.nsfwLevel.value,
        'subscription': {
          'premium_tier': server.settings.subscription.tier.value,
          'premium_subscription_count': server.settings.subscription.subscriptionCount,
          'premium_progress_bar_enabled': server.settings.subscription.hasEnabledProgressBar,
        }
      },
      'channel_settings': {
        'afk_channel_id': server.channels.afkChannelId?.value,
        'system_channel_id': server.channels.systemChannelId?.value,
        'rules_channel_id': server.channels.rulesChannelId?.value,
        'public_updates_channel_id': server.channels.publicUpdatesChannelId?.value,
        'safety_alerts_channel_id': server.channels.safetyAlertsChannelId?.value,
      },
    };
  }
}
