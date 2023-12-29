import 'package:mineral/domains/events/events/message_create_event.dart';
import 'package:mineral/domains/events/events/ready_event.dart';

enum PacketType {
  ready('READY', ReadyEvent),
  messageCreate('MESSAGE_CREATE', MessageCreateEvent);

  final String name;
  final Type type;

  const PacketType(this.name, this.type);

  @override
  String toString() => type.toString();
}
