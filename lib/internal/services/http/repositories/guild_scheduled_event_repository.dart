final class GuildScheduledEventRepository {
  /// Get a guild's scheduled events
  /// Related to the official [Discord API documentation](https://discord.com/developers/docs/resources/guild-scheduled-event#list-scheduled-events-for-guild)
  /// ```dart
  /// final events = await http.endpoints.scheduledEvents.list(guildId: '1234567890');
  /// ```
  String list(String guildId) => Uri(pathSegments: ['guilds', guildId, 'scheduled-events']).path;

  /// Create a guild's scheduled event
  /// Related to the official [Discord API documentation](https://discord.com/developers/docs/resources/guild-scheduled-event#create-guild-scheduled-event)
  /// ```dart
  /// final event = await http.endpoints.scheduledEvents.create(guildId: '1234567890');
  /// ```
  String create(String guildId) => Uri(pathSegments: ['guilds', guildId, 'scheduled-events']).path;

  /// Get a guild's scheduled event
  /// Related to the official [Discord API documentation](https://discord.com/developers/docs/resources/guild-scheduled-event#get-guild-scheduled-event)
  /// ```dart
  /// final event = await http.endpoints.scheduledEvents.get(guildId: '1234567890', eventId: '1234567890');
  /// ```
  String get(String guildId, String eventId) => Uri(pathSegments: ['guilds', guildId, 'scheduled-events', eventId]).path;

  /// Update a guild's scheduled event
  /// Related to the official [Discord API documentation](https://discord.com/developers/docs/resources/guild-scheduled-event#modify-guild-scheduled-event)
  /// ```dart
  /// final event = await http.endpoints.scheduledEvents.update(guildId: '1234567890', eventId: '1234567890');
  /// ```
  String update(String guildId, String eventId) => Uri(pathSegments: ['guilds', guildId, 'scheduled-events', eventId]).path;

  /// Delete a guild's scheduled event
  /// Related to the official [Discord API documentation](https://discord.com/developers/docs/resources/guild-scheduled-event#delete-guild-scheduled-event)
  /// ```dart
  /// final event = await http.endpoints.scheduledEvents.delete(guildId: '1234567890', eventId: '1234567890');
  /// ```
  String delete(String guildId, String eventId) => Uri(pathSegments: ['guilds', guildId, 'scheduled-events', eventId]).path;

  /// Get a guild's scheduled event's users
  /// Related to the official [Discord API documentation](https://discord.com/developers/docs/resources/guild-scheduled-event#get-guild-scheduled-event-users)
  /// ```dart
  /// final users = await http.endpoints.scheduledEvents.getUsers(guildId: '1234567890', eventId: '1234567890');
  /// ```
  String getUsers(String guildId, String eventId) => Uri(pathSegments: ['guilds', guildId, 'scheduled-events', eventId, 'users']).path;
}