import 'package:mineral/contracts.dart';
import 'package:mineral/src/domains/contracts/wss/constants/op_code.dart';

final class ShardMessage<T> implements ShardMessageContract<T, OpCode> {
  @override
  final String? type;

  @override
  final OpCode opCode;

  @override
  final int? sequence;

  @override
  final T payload;

  ShardMessage(
      {required this.type,
      required this.opCode,
      required this.sequence,
      required this.payload});

  factory ShardMessage.of(Map<String, dynamic> message) => ShardMessage(
      type: message['t'],
      opCode:
          OpCode.values.firstWhere((element) => element.value == message['op']),
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
