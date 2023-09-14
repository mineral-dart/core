/// Repository for the StageInstance
/// Related official [documentation](https://discord.com/developers/docs/resources/stage-instance)
final class StageInstanceRepository {
  /// Get one stage instance from Discord API.
  /// Related [official documentation](https://discord.com/developers/docs/resources/stage-instance#get-stage-instance)
  /// ```dart
  /// final uri = http.endpoints.stageInstances.one('1234');
  /// ```
  String one({ required String channelId }) =>
      Uri(pathSegments: ['stage-instances', channelId]).path;

  /// Create one stage instance from Discord API.
  /// Related [official documentation](https://discord.com/developers/docs/resources/stage-instance#create-stage-instance)
  /// ```dart
  /// final uri = http.endpoints.stageInstances.create('1234');
  /// ```
  String create({ required String channelId }) =>
      Uri(pathSegments: ['stage-instances', channelId]).path;

  /// Update one stage instance from Discord API.
  /// Related [official documentation](https://discord.com/developers/docs/resources/stage-instance#update-stage-instance)
  /// ```dart
  /// final uri = http.endpoints.stageInstances.update('1234');
  /// ```
  String update({ required String channelId }) =>
      Uri(pathSegments: ['stage-instances', channelId]).path;

  /// Delete one stage instance from Discord API.
  /// Related [official documentation](https://discord.com/developers/docs/resources/stage-instance#delete-stage-instance)
  /// ```dart
  /// final uri = http.endpoints.stageInstances.delete('1234');
  /// ```
  String delete({ required String channelId }) =>
      Uri(pathSegments: ['stage-instances', channelId]).path;
}