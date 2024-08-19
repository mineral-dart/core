import 'package:mineral/api/server/enums/default_message_notification.dart';
import 'package:mineral/api/server/enums/explicit_content_filter.dart';
import 'package:mineral/api/server/enums/mfa_level.dart';
import 'package:mineral/api/server/enums/nsfw_level.dart';
import 'package:mineral/api/server/enums/system_channel_flag.dart';
import 'package:mineral/api/server/enums/verification_level.dart';
import 'package:mineral/api/server/server_settings.dart';
import 'package:mineral/infrastructure/commons/utils.dart';
import 'package:mineral/infrastructure/internals/marshaller/marshaller.dart';
import 'package:mineral/infrastructure/internals/marshaller/types/serializer.dart';

final class ServerSettingsSerializer implements SerializerContract<ServerSettings> {
  final MarshallerContract _marshaller;

  ServerSettingsSerializer(this._marshaller);

  @override
  Future<void> normalize(Map<String, dynamic> json) async {
    final payload = {
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
    };

    final cacheKey = _marshaller.cacheKey.serverSettings(json['id']);
    await _marshaller.cache.put(cacheKey, payload);
  }

  @override
  Future<ServerSettings> serialize(Map<String, dynamic> json) async {
    final subscription = await _marshaller.serializers.serverSubscription.serialize({
      'premium_tier': json['premium_tier'],
      'premium_subscription_count': json['premium_subscription_count'],
      'premium_progress_bar_enabled': json['premium_progress_bar_enabled'],
    });

    return ServerSettings(
        bitfieldPermission: json['permissions'],
        afkTimeout: json['afk_timeout'],
        hasWidgetEnabled: json['widget_enabled'] ?? false,
        explicitContentFilter:
            findInEnum(ExplicitContentFilter.values, json['explicit_content_filter']),
        verificationLevel: findInEnum(VerificationLevel.values, json['verification_level']),
        defaultMessageNotifications:
            findInEnum(DefaultMessageNotification.values, json['default_message_notifications']),
        features: List<String>.from(json['features']),
        mfaLevel: findInEnum(MfaLevel.values, json['mfa_level']),
        systemChannelFlags: bitfieldToList(SystemChannelFlag.values, json['system_channel_flags']),
        vanityUrlCode: json['vanity_url_code'],
        subscription: subscription,
        preferredLocale: json['preferred_locale'],
        maxVideoChannelUsers: json['max_video_channel_users'],
        nsfwLevel: findInEnum(NsfwLevel.values, json['nsfw_level']));
  }

  @override
  Future<Map<String, dynamic>> deserialize(ServerSettings settings) async {
    return {
      'permissions': settings.bitfieldPermission,
      'afk_timeout': settings.afkTimeout,
      'widget_enabled': settings.hasWidgetEnabled,
      'explicit_content_filter': settings.explicitContentFilter.value,
      'verification_level': settings.verificationLevel.value,
      'default_message_notifications': settings.defaultMessageNotifications.value,
      'features': settings.features,
      'mfa_level': settings.mfaLevel.value,
      'system_channel_flags': settings.systemChannelFlags,
      'vanity_url_code': settings.vanityUrlCode,
      'premium_tier': settings.subscription.tier.value,
      'premium_subscription_count': settings.subscription.subscriptionCount,
      'premium_progress_bar_enabled': settings.subscription.hasEnabledProgressBar,
      'preferred_locale': settings.preferredLocale,
      'max_video_channel_users': settings.maxVideoChannelUsers,
      'nsfw_level': settings.nsfwLevel.value,
    };
  }
}
