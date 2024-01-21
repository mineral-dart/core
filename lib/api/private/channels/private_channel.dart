import 'package:mineral/api/common/channel.dart';

final class PrivateChannel extends Channel {
  PrivateChannel({
    required String id,
    required String name,
  }): super(id, name);

  factory PrivateChannel.fromJson(Map<String, dynamic> json) {
    return PrivateChannel(
      id: json['channel_id'],
      name: json['author']['username'],
    );
  }
}
