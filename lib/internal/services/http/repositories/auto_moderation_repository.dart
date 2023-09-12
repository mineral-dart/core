/// Repository for the [AutoModeration]
///
/// Related [official documentation](https://discord.com/developers/docs/resources/auto-moderation)
final class AutoModerationRepository {
  /// Returns a list of [AutoModeration] objects for the given [Guild].
  /// Related to the official Discord API documentation: https://discord.com/developers/docs/resources/auto-moderation#list-auto-moderation-rules-for-guild
  /// ```dart
  /// final moderation = await client.moderation.list(guildId: '1234567890');
  /// ```
  String list({ required String guildId }) => Uri(pathSegments: ['guilds', guildId, 'auto-moderation', 'rules']).path;

  /// Returns an [AutoModeration] object for the given [Guild] and rule IDs.
  /// Related to the official Discord API documentation: https://discord.com/developers/docs/resources/auto-moderation#get-auto-moderation-rule
  /// ```dart
  /// final moderation = await client.moderation.get(guildId: '1234567890', ruleId: '1234567890');
  /// ```
  String get({ required String guildId, required String ruleId }) =>
      Uri(pathSegments: ['guilds', guildId, 'auto-moderation', 'rules', ruleId]).path;

  /// Create a new [AutoModeration] for the given [Guild].
  /// Related to the official Discord API documentation: https://discord.com/developers/docs/resources/auto-moderation#create-auto-moderation-rule
  /// ```dart
  /// final moderation = await client.moderation.create(guildId: '1234567890', ruleId: '1234567890');
  /// ```
  String create({ required String guildId }) => Uri(pathSegments: ['guilds', guildId, 'auto-moderation', 'rules']).path;

  /// Modify the given [AutoModeration].
  /// Related to the official Discord API documentation: https://discord.com/developers/docs/resources/auto-moderation#modify-auto-moderation-rule
  /// ```dart
  /// final moderation = await client.moderation.update(guildId: '1234567890', ruleId: '1234567890');
  /// ```
  String update({ required String guildId, required String ruleId }) =>
      Uri(pathSegments: ['guilds', guildId, 'auto-moderation', 'rules', ruleId]).path;

  /// Delete the given [AutoModeration].
  /// Related to the official Discord API documentation: https://discord.com/developers/docs/resources/auto-moderation#delete-auto-moderation-rule
  /// ```dart
  /// final moderation = await client.moderation.delete(guildId: '1234567890', ruleId: '1234567890');
  /// ```
  String delete({ required String guildId, required String ruleId }) =>
      Uri(pathSegments: ['guilds', guildId, 'auto-moderation', 'rules', ruleId]).path;
}