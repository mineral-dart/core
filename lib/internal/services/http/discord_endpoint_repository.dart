import 'package:mineral/internal/services/http/repositories/channel_repository.dart';
import 'package:mineral/internal/services/http/repositories/emoji_repository.dart';

final class DiscordEndpointRepository {
  final ChannelRepository channels = ChannelRepository();
  final EmojiRepository emojis = EmojiRepository();
}