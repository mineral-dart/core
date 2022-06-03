import 'package:mineral/api.dart';

class User {
  Snowflake id;
  String username;
  String tag;
  String discriminator;
  bool bot = false;
  int publicFlags;
  String? avatar;
  late Status status;

  User({
    required this.id,
    required this.username,
    required this.tag,
    required this.discriminator,
    required this.bot,
    required this.publicFlags,
    required this.avatar,
  });

  factory User.from(dynamic payload) {
    return User(
      id: payload['id'],
      username: payload['username'],
      tag: "${payload['username']}#${payload['discriminator']}",
      discriminator: payload['discriminator'],
      bot: payload['bot'] == true,
      publicFlags: payload['public_flags'] ?? 0,
      avatar: payload['avatar'],
    );
  }
}
