import 'package:mineral/api.dart';
import 'package:mineral/src/constants.dart';

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

  String getDisplayAvatarUrl () {
    return "${Constants.cdnUrl}/avatars/$id/$avatar";
  }

  @override
  String toString () => "<@$id>";

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
