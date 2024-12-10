import 'dart:convert';

import 'package:mineral/src/domains/contracts/wss/constants/op_code.dart';

final class ShardMessageBuilder<OpCodeEnum extends OpCode> {
  OpCodeEnum? _code;
  Map<String, dynamic>? _payload;

  ShardMessageBuilder();

  ShardMessageBuilder setOpCode(OpCodeEnum code) {
    _code = code;
    return this;
  }

  ShardMessageBuilder append(String key, dynamic payload) {
    _payload ??= {};
    _payload![key] = payload;

    return this;
  }

  String build() {
    return jsonEncode({
      'op': _code!.value,
      'd': _payload,
    });
  }
}
