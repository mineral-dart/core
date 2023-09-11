import 'package:mineral/internal/services/http/repositories/auto_moderation_repository.dart';
import 'package:mineral/internal/services/http/repositories/channel_repository.dart';
import 'package:mineral/internal/services/http/repositories/emoji_repository.dart';

final class DiscordEndpointRepository {
  /// Get [Channel] endpoints
  final ChannelRepository channels = ChannelRepository();

  /// Get [Emoji] endpoints
  final EmojiRepository emojis = EmojiRepository();

  /// Get [AutoModeration] endpoints
  final AutoModerationRepository moderation = AutoModerationRepository();
}