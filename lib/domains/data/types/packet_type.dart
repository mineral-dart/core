import 'package:mineral/domains/data/events/message_create_event.dart';
import 'package:mineral/domains/data/events/ready_event.dart';
import 'package:mineral/domains/data/events/server_create_event.dart';

enum PacketType {
  ready('READY', ReadyEvent),
  messageCreate('MESSAGE_CREATE', MessageCreateEvent),
  guildCreate('GUILD_CREATE', ServerCreateEvent);

  final String name;
  final Type type;

  const PacketType(this.name, this.type);

  @override
  String toString() => type.toString();
}
