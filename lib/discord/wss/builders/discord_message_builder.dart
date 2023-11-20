import 'dart:convert';

import 'package:mineral/discord/wss/constants/op_code.dart';

final class DiscordMessageBuilder {
  OpCode? _code;
  Map<String, dynamic>? _payload;

  DiscordMessageBuilder();

  DiscordMessageBuilder setOpCode(OpCode code) {
    _code = code;
    return this;
  }

  DiscordMessageBuilder append(String key, dynamic payload) {
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
