final class ChannelRepository {
  /// Get one channel from Discord API.
  /// Related [official documentation](https://discord.com/developers/docs/resources/channel#get-channel)
  /// ```dart
  /// final uri = http.endpoints.channels.one('1234');
  /// ```
  String one({ required String channelId }) =>
      Uri(pathSegments: ['channels', channelId]).path;

  /// Update one channel from Discord API.
  /// Related [official documentation](https://discord.com/developers/docs/resources/channel#modify-channel)
  /// ```dart
  /// final uri = http.endpoints.channels.update('1234');
  /// ```
  String update({ required String channelId }) =>
      Uri(pathSegments: ['channels', channelId]).path;

  /// Delete one channel from Discord API.
  /// Related [official documentation](https://discord.com/developers/docs/resources/channel#deleteclose-channel)
  /// ```dart
  /// final uri = http.endpoints.channels.delete('1234');
  /// ```
  String delete({ required String channelId }) =>
      Uri(pathSegments: ['channels', channelId]).path;
}