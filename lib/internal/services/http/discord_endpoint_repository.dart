import 'package:mineral/internal/services/http/repositories/audit_log_repository.dart';
import 'package:mineral/internal/services/http/repositories/auto_moderation_repository.dart';
import 'package:mineral/internal/services/http/repositories/channel_repository.dart';
import 'package:mineral/internal/services/http/repositories/emoji_repository.dart';
import 'package:mineral/internal/services/http/repositories/guild_repository.dart';
import 'package:mineral/internal/services/http/repositories/guild_scheduled_event_repository.dart';

final class DiscordEndpointRepository {
  /// Get [Channel] endpoints
  final ChannelRepository channels = ChannelRepository();

  /// Get [Emoji] endpoints
  final EmojiRepository emojis = EmojiRepository();

  /// Get [AutoModeration] endpoints
  final AutoModerationRepository moderation = AutoModerationRepository();

  /// Get [AuditLog] endpoints
  final AuditLogRepository auditLogs = AuditLogRepository();

  /// Get [Guild] endpoints
  final GuildRepository guilds = GuildRepository();

  /// Get [ScheduledEvent] endpoints
  final GuildScheduledEventRepository scheduledEvents = GuildScheduledEventRepository();
}