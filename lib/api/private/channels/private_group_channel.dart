import 'package:mineral/api/common/channel.dart';
import 'package:mineral/api/common/snowflake.dart';

final class PrivateGroupChannel extends Channel {
  final List<String> users;

  PrivateGroupChannel({
    required Snowflake id,
    required String name,
    required this.users,
  }): super(id, name);
}
