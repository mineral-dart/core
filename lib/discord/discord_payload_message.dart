import 'package:mineral/discord/op_code.dart';

abstract interface class DiscordPayloadMessage<T> {
  String? get type;

  OpCode get opCode;

  int? get sequence;

  T get payload;
}

final class DiscordPayloadMessageImpl<T> implements DiscordPayloadMessage<T> {
  @override
  final String? type;

  @override
  final OpCode opCode;

  @override
  final int? sequence;

  @override
  final T payload;

  DiscordPayloadMessageImpl(
      {required this.type,
      required this.opCode,
      required this.sequence,
      required this.payload});

  factory DiscordPayloadMessageImpl.of(Map<String, dynamic> message) =>
      DiscordPayloadMessageImpl(
          type: message['t'],
          opCode: OpCode.values
              .firstWhere((element) => element.value == message['op']),
          sequence: message['s'],
          payload: message['d']);
}
