import 'package:mineral/api/common/channel.dart';
import 'package:mineral/api/private/user.dart';
import 'package:mineral/api/common/snowflake.dart';

final class PrivateChannel extends Channel {
  final List<User> recipients;
  PrivateChannel({
    required Snowflake id,
    required String name,
    required this.recipients,
  }): super(id, name);

  factory PrivateChannel.fromJson(Map<String, dynamic> json) {
    final List<User> recipients = [];

    for (final recipient in json['recipients']) {
      recipients.add(User.fromJson(recipient));
    }

    return PrivateChannel(
      id: json['id'],
      name: recipients.map((e) => e.username).join(', '),
      recipients: recipients,
    );
  }
}
