abstract class HttpConfigContract {
  /// The base url for the discord api.
  final String baseUrl;

  /// The version of the discord api.
  /// Related to the official [Discord API](https://discord.com/developers/docs/reference#api-versioning) documentation
  final int version;

  HttpConfigContract({
    required this.baseUrl,
    required this.version,
  });
}