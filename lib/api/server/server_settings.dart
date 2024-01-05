import 'package:mineral/api/server/enums/default_message_notification.dart';
import 'package:mineral/api/server/enums/explicit_content_filter.dart';
import 'package:mineral/api/server/enums/mfa_level.dart';
import 'package:mineral/api/server/enums/nsfw_level.dart';
import 'package:mineral/api/server/enums/system_channel_flag.dart';
import 'package:mineral/api/server/enums/verification_level.dart';
import 'package:mineral/api/server/server_subscription.dart';
import 'package:mineral/domains/shared/utils.dart';

final class ServerSettings {
  final String? bitfieldPermission;
  final int? afkTimeout;
  final bool hasWidgetEnabled;
  final VerificationLevel verificationLevel;
  final DefaultMessageNotification defaultMessageNotifications;
  final ExplicitContentFilter explicitContentFilter;
  final List<String> features;
  final MfaLevel mfaLevel;
  final List<SystemChannelFlag> systemChannelFlags;
  final String? vanityUrlCode;
  final ServerSubscription subscription;
  final String preferredLocale;
  final int? maxVideoChannelUsers;
  final NsfwLevel nsfwLevel;

  ServerSettings({
    required this.bitfieldPermission,
    required this.afkTimeout,
    required this.hasWidgetEnabled,
    required this.verificationLevel,
    required this.defaultMessageNotifications,
    required this.explicitContentFilter,
    required this.features,
    required this.mfaLevel,
    required this.systemChannelFlags,
    required this.vanityUrlCode,
    required this.subscription,
    required this.preferredLocale,
    required this.maxVideoChannelUsers,
    required this.nsfwLevel,
  });

  factory ServerSettings.fromJson(Map<String, dynamic> json) {
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
        subscription: ServerSubscription.fromJson(json),
        preferredLocale: json['preferred_locale'],
        maxVideoChannelUsers: json['max_video_channel_users'],
        nsfwLevel: findInEnum(NsfwLevel.values, json['nsfw_level']));
  }
}
