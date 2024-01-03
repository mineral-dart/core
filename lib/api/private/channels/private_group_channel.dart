import 'package:mineral/api/common/channel.dart';

final class PrivateChannel extends Channel {
  final List<String> users;

  PrivateChannel({
    required String id,
    required String name,
    required this.users,
  }): super(id, name);
}
