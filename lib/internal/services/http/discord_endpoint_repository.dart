import 'package:mineral/internal/services/http/repositories/audit_log_repository.dart';
import 'package:mineral/internal/services/http/repositories/auto_moderation_repository.dart';
import 'package:mineral/internal/services/http/repositories/channel_repository.dart';
import 'package:mineral/internal/services/http/repositories/emoji_repository.dart';
import 'package:mineral/internal/services/http/repositories/guild_repository.dart';
import 'package:mineral/internal/services/http/repositories/guild_scheduled_event_repository.dart';
import 'package:mineral/internal/services/http/repositories/guild_template_repository.dart';
import 'package:mineral/internal/services/http/repositories/invite_repository.dart';
import 'package:mineral/internal/services/http/repositories/state_instance_repository.dart';
import 'package:mineral/internal/services/http/repositories/sticker_repository.dart';
import 'package:mineral/internal/services/http/repositories/user_repository.dart';
import 'package:mineral/internal/services/http/repositories/voice_repository.dart';
import 'package:mineral/internal/services/http/repositories/webhook_repository.dart';

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

  /// Get [GuildTemplate] endpoints
  final GuildTemplateRepository templates = GuildTemplateRepository();

  /// Get [Invite] endpoints
  final InviteRepository invites = InviteRepository();

  /// Get [StageInstance] endpoints
  final StageInstanceRepository stageInstances = StageInstanceRepository();

  /// Get [Sticker] endpoints
  final StickerRepository stickers = StickerRepository();

  /// Get [User] endpoints
  final UserRepository users = UserRepository();

  /// Get [Voice] endpoints
  final VoiceRepository voice = VoiceRepository();

  /// Get [Webhook] endpoints
  final WebhookRepository webhooks = WebhookRepository();
}