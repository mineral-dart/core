import 'package:mineral/api/common/channel.dart';
import 'package:mineral/api/common/snowflake.dart';
import 'package:mineral/api/common/types/channel_type.dart';
import 'package:mineral/api/private/user.dart';

final class PrivateChannel extends Channel {
  final List<User> recipients;
  PrivateChannel({
    required Snowflake id,
    required String name,
    required this.recipients,
  }): super(id, ChannelType.dm, name);

  factory PrivateChannel.fromJson(Map<String, dynamic> json) {
    final List<User> recipients = [];

    for (final recipient in json['recipients']) {
      recipients.add(User.fromJson(recipient));
    }

    return PrivateChannel(
      id: Snowflake(json['id']),
      name: recipients.map((e) => e.username).join(', '),
      recipients: recipients,
    );
  }
}
