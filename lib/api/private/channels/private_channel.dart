import 'package:mineral/api/common/channel.dart';

final class PrivateChannel implements Channel {
  @override
  final String id;

  @override
  final String name;

  PrivateChannel({
    required this.id,
    required this.name,
  });
}
