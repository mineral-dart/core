import 'package:mineral/domains/wss/constants/op_code.dart';

abstract interface class ShardMessage<T> {
  String? get type;

  OpCode get opCode;

  int? get sequence;

  T get payload;

  Object serialize();
}

final class ShardMessageImpl<T> implements ShardMessage<T> {
  @override
  final String? type;

  @override
  final OpCode opCode;

  @override
  final int? sequence;

  @override
  final T payload;

  ShardMessageImpl(
      {required this.type, required this.opCode, required this.sequence, required this.payload});

  factory ShardMessageImpl.of(Map<String, dynamic> message) => ShardMessageImpl(
      type: message['t'],
      opCode: OpCode.values.firstWhere((element) => element.value == message['op']),
      sequence: message['s'],
      payload: message['d']);

  @override
  Object serialize() {
    return {
      't': type,
      'op': opCode.value,
      's': sequence,
      'd': payload,
    };
  }
}
