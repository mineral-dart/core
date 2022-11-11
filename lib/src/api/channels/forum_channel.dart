import 'package:mineral/api.dart';
import 'package:mineral/builders.dart';
import 'package:mineral/src/api/managers/forum_discussion_manager.dart';
import 'package:mineral/src/api/managers/permission_overwrite_manager.dart';

class ForumChannel extends GuildChannel {
  final ForumDiscussionManager _discussions;

  ForumChannel(
    super.guildId,
    super.parentId,
    super.label,
    super.type,
    super.position,
    super.flags,
    super.permissions,
    super.id,
    this._discussions,
  );

  ForumDiscussionManager get discussions => _discussions;

  /// Defines the default emoji of this
  /// ```dart
  /// final channel = guild.channels.cache.getOrFail('...');
  /// await channel.setDefaultReactionEmoji(EmojiBuilder.fromUnicode('🧱'));
  /// ```
  Future<void> setDefaultReactionEmoji (EmojiBuilder emoji) async {
    final _emoji = {};
    if (emoji.emoji.id.isNotEmpty) {
      _emoji.putIfAbsent('emoji_id', () => emoji.emoji.id);
    }

    if (emoji.emoji.label.isNotEmpty) {
      _emoji.putIfAbsent('emoji_name', () => emoji.emoji.label);
    }

    await update(ChannelBuilder({
      'default_reaction_emoji': _emoji
    }));
  }

  /// Defines the tags of this
  /// ```dart
  /// final channel = guild.channels.cache.getOrFail('...');
  /// await channel.setTags([
  ///   ForumTagBuilder(label: 'Hello world !', moderated: false),
  ///   ForumTagBuilder(label: 'Hello world !', moderated: false, emoji: EmojiBuilder.fromUnicode('🧱')),
  /// ]);
  /// ```
  Future<void> setTags (List<ForumTagBuilder> tags) async {
    await update(ChannelBuilder({
      'available_tags': [...tags.map((tag) => tag.toJson())]
    }));
  }

  /// Defines the default rate limit per user of this
  /// ```dart
  /// final channel = guild.channels.cache.getOrFail('...');
  /// await channel.setRateLimit(Duration(seconds: 5));
  /// ```
  Future<void> setDefaultRateLimit (Duration duration) async {
    await update(ChannelBuilder({
      'default_thread_rate_limit_per_user': duration.inMilliseconds
    }));
  }

  factory ForumChannel.fromPayload(dynamic payload) {
    final permissionOverwriteManager = PermissionOverwriteManager();
    for (dynamic element in payload['permission_overwrites']) {
      final PermissionOverwrite overwrite = PermissionOverwrite.from(payload: element);
      permissionOverwriteManager.cache.putIfAbsent(overwrite.id, () => overwrite);
    }

    return ForumChannel(
      payload['guild_id'],
      payload['parent_id'],
      payload['name'],
      payload['type'],
      payload['position'],
      payload['flags'],
      permissionOverwriteManager,
      payload['id'],
      ForumDiscussionManager(payload['id']),
    );
  }
}
