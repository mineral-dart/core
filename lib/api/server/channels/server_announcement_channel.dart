import 'package:mineral/api/server/channels/server_channel.dart';

final class ServerAnnouncementChannel extends ServerChannel {
  final String? description;

  ServerAnnouncementChannel({
    required String id,
    required String name,
    required int position,
    required this.description,
  }): super(id, name, position);

  factory ServerAnnouncementChannel.fromJson(String guildId, Map<String, dynamic> json) {
    return ServerAnnouncementChannel(
      id: json['id'],
      name: json['name'],
      position: json['position'],
      description: json['description'],
    );
  }
}
