import 'package:mineral/api/common/channel.dart';

final class PrivateGroupChannel extends Channel {
  final List<String> users;

  PrivateGroupChannel({
    required String id,
    required String name,
    required this.users,
  }): super(id, name);
}
