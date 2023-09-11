/// Repository for the [Emoji] resource.
/// Related official documentation: https://discord.com/developers/docs/resources/emoji
final class EmojiRepository {
  /// Returns a list of [Emoji] objects for the given [Guild].
  /// Related to the official Discord API documentation: https://discord.com/developers/docs/resources/emoji#list-guild-emojis
  /// ```dart
  /// final emojis = await client.emojis.list(guildId: '1234567890');
  /// ```
  String list(String guildId) => Uri(pathSegments: ['guilds', guildId, 'emojis']).path;

  /// Returns an [Emoji] object for the given [Guild] and emoji IDs.
  /// Related to the official Discord API documentation: https://discord.com/developers/docs/resources/emoji#get-guild-emoji
  /// ```dart
  /// final emoji = await client.emojis.get(guildId: '1234567890', emojiId: '1234567890');
  /// ```
  String get(String guildId, String emojiId) => Uri(pathSegments: ['guilds', guildId, 'emojis', emojiId]).path;

  /// Create a new [Emoji] for the given [Guild].
  /// Related to the official Discord API documentation: https://discord.com/developers/docs/resources/emoji#create-guild-emoji
  /// ```dart
  /// final emoji = await client.emojis.create(guildId: '1234567890', emojiId: '1234567890');
  /// ```
  String create(String guildId) => Uri(pathSegments: ['guilds', guildId, 'emojis']).path;

  /// Modify the given [Emoji].
  /// Related to the official Discord API documentation: https://discord.com/developers/docs/resources/emoji#modify-guild-emoji
  /// ```dart
  /// final emoji = await client.emojis.update(guildId: '1234567890', emojiId: '1234567890');
  /// ```
  String update(String guildId, String emojiId) => Uri(pathSegments: ['guilds', guildId, 'emojis', emojiId]).path;

  /// Delete the given [Emoji].
  /// Related to the official Discord API documentation: https://discord.com/developers/docs/resources/emoji#delete-guild-emoji
  /// ```dart
  /// final emoji = await client.emojis.delete(guildId: '1234567890', emojiId: '1234567890');
  /// ```
  String delete(String guildId, String emojiId) => Uri(pathSegments: ['guilds', guildId, 'emojis', emojiId]).path;
}