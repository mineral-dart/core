/// Voice repository
/// Related official [documentation](https://discord.com/developers/docs/resources/voice)
final class VoiceRepository {
  /// Get voice regions from Discord API.
  /// Related [official documentation](https://discord.com/developers/docs/resources/voice#list-voice-regions)
  /// ```dart
  /// final uri = http.endpoints.voice.regions();
  /// ```
  String regions() => Uri(pathSegments: ['voice', 'regions']).path;
}