import 'package:mineral/api/api/common/channel.dart';

final class PrivateChannel implements Channel {
  @override
  final String id;

  @override
  final String name;

  final List<String> users;

  PrivateChannel({
    required this.id,
    required this.name,
    required this.users,
  });
}
