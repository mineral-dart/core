import 'dart:convert';

import 'package:mineral/src/domains/services/wss/constants/op_code.dart';

final class ShardMessageBuilder<OpCodeEnum extends OpCode> {
  OpCodeEnum? _code;
  Map<String, dynamic>? _payload;

  ShardMessageBuilder();

  void setOpCode(OpCodeEnum code) => _code = code;

  void append(String key, dynamic payload) {
    _payload ??= {};
    _payload![key] = payload;
  }

  Map<String, dynamic> toJson() {
    return {
      'op': _code!.value,
      'd': _payload,
    };
  }

  String build() {
    return jsonEncode({
      'op': _code!.value,
      'd': _payload,
    });
  }
}
