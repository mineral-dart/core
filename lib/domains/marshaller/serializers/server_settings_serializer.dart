import 'package:mineral/api/server/enums/default_message_notification.dart';
import 'package:mineral/api/server/enums/explicit_content_filter.dart';
import 'package:mineral/api/server/enums/mfa_level.dart';
import 'package:mineral/api/server/enums/nsfw_level.dart';
import 'package:mineral/api/server/enums/system_channel_flag.dart';
import 'package:mineral/api/server/enums/verification_level.dart';
import 'package:mineral/api/server/server_settings.dart';
import 'package:mineral/domains/marshaller/marshaller.dart';
import 'package:mineral/domains/marshaller/types/serializer.dart';
import 'package:mineral/domains/shared/utils.dart';

final class ServerSettingsSerializer implements SerializerContract<ServerSettings> {
  final MarshallerContract _marshaller;

  ServerSettingsSerializer(this._marshaller);

  @override
  Future<ServerSettings> serialize(Map<String, dynamic> json) async {
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
        subscription: await _marshaller.serializers.serverSubscription.serialize(json),
        preferredLocale: json['preferred_locale'],
        maxVideoChannelUsers: json['max_video_channel_users'],
        nsfwLevel: findInEnum(NsfwLevel.values, json['nsfw_level']));
  }

  @override
  Future<Map<String, dynamic>> deserialize(ServerSettings object) async {
    final subscriptions = await _marshaller.serializers.serverSubscription.deserialize(object.subscription);

    return {
      'permissions': object.bitfieldPermission,
      'afk_timeout': object.afkTimeout,
      'widget_enabled': object.hasWidgetEnabled,
      'explicit_content_filter': object.explicitContentFilter.value,
      'verification_level': object.verificationLevel.value,
      'default_message_notifications': object.defaultMessageNotifications.value,
      'features': object.features,
      'mfa_level': object.mfaLevel.value,
      'system_channel_flags': listToBitfield(object.systemChannelFlags),
      'vanity_url_code': object.vanityUrlCode,
      'preferred_locale': object.preferredLocale,
      'max_video_channel_users': object.maxVideoChannelUsers,
      'nsfw_level': object.nsfwLevel.value,
      ...subscriptions
    };
  }
}
