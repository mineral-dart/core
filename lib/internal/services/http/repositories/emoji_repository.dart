/// Repository for the [Emoji] resource.
/// Related official documentation: https://discord.com/developers/docs/resources/emoji
final class EmojiRepository {
  /// Returns a list of [Emoji] objects for the given [Guild].
  /// Related to the official Discord API documentation: https://discord.com/developers/docs/resources/emoji#list-guild-emojis
  /// ```dart
  /// final emojis = await http.endpoints.emojis.list(guildId: '1234567890');
  /// ```
  String list({ required String guildId }) =>
      Uri(pathSegments: ['guilds', guildId, 'emojis']).path;

  /// Returns an [Emoji] object for the given [Guild] and emoji IDs.
  /// Related to the official Discord API documentation: https://discord.com/developers/docs/resources/emoji#get-guild-emoji
  /// ```dart
  /// final emoji = await http.endpoints.emojis.get(guildId: '1234567890', emojiId: '1234567890');
  /// ```
  String get({ required String guildId, required String emojiId }) =>
      Uri(pathSegments: ['guilds', guildId, 'emojis', emojiId]).path;

  /// Create a new [Emoji] for the given [Guild].
  /// Related to the official Discord API documentation: https://discord.com/developers/docs/resources/emoji#create-guild-emoji
  /// ```dart
  /// final emoji = await http.endpoints.emojis.create(guildId: '1234567890', emojiId: '1234567890');
  /// ```
  String create({ required String guildId }) =>
      Uri(pathSegments: ['guilds', guildId, 'emojis']).path;

  /// Modify the given [Emoji].
  /// Related to the official Discord API documentation: https://discord.com/developers/docs/resources/emoji#modify-guild-emoji
  /// ```dart
  /// final emoji = await http.endpoints.emojis.update(guildId: '1234567890', emojiId: '1234567890');
  /// ```
  String update({ required String guildId, required String emojiId }) =>
      Uri(pathSegments: ['guilds', guildId, 'emojis', emojiId]).path;

  /// Delete the given [Emoji].
  /// Related to the official Discord API documentation: https://discord.com/developers/docs/resources/emoji#delete-guild-emoji
  /// ```dart
  /// final emoji = await http.endpoints.emojis.delete(guildId: '1234567890', emojiId: '1234567890');
  /// ```
  String delete({ required String guildId, required String emojiId }) =>
      Uri(pathSegments: ['guilds', guildId, 'emojis', emojiId]).path;
}