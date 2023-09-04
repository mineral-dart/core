import 'package:mineral/core/api.dart';
import 'package:mineral/core/builders.dart';

class GuildBuilder {
  final String name;
  final String? icon;
  final VerificationLevel? verificationLevel;
  final NotificationLevel? defaultMessageNotifications;
  final ExplicitContentFilterLevel? explicitContentFilter;
  final List<ChannelBuilder> channels;
  final SystemChannelFlags? systemChannelFlags;

  GuildBuilder({
    required this.name,
    this.icon,
    this.verificationLevel,
    this.defaultMessageNotifications,
    this.explicitContentFilter,
    this.channels = const [],
    this.systemChannelFlags,
  });

  Map<String, dynamic> get toJson => {
    'name': name,
    'icon': icon,
    'verification_level': verificationLevel?.value,
    'default_message_notifications': defaultMessageNotifications?.value,
    'explicit_content_filter': explicitContentFilter?.value,
    'channels': channels.map((channel) => channel.payload).toList(),
    'system_channel_flags': systemChannelFlags?.value,
  };
}