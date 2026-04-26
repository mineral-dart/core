final class RedisSettings {
  final String host;
  final int port;
  final bool hasPassword;

  RedisSettings(this.host, this.port, {this.hasPassword = false});
}
