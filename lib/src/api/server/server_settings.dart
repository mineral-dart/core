import 'package:mineral/src/api/server/enums/default_message_notification.dart';
import 'package:mineral/src/api/server/enums/explicit_content_filter.dart';
import 'package:mineral/src/api/server/enums/mfa_level.dart';
import 'package:mineral/src/api/server/enums/nsfw_level.dart';
import 'package:mineral/src/api/server/enums/system_channel_flag.dart';
import 'package:mineral/src/api/server/enums/verification_level.dart';
import 'package:mineral/src/api/server/server_subscription.dart';

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
}
