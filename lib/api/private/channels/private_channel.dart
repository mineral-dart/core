import 'package:mineral/api/common/channel.dart';

final class PrivateChannel extends Channel {
  PrivateChannel({
    required String id,
    required String name,
  }): super(id, name);
}
