import 'dart:async';
import 'dart:io' as dart_io;

import 'package:mineral/application/io/ffi/terminal.dart';
import 'package:mineral/application/io/key_stroke.dart';


const _asyncRunZoned = runZoned;

abstract class TerminalOverrides {
  static final _token = Object();

  static TerminalOverrides? get current {
    return Zone.current[_token] as TerminalOverrides?;
  }

  static R runZoned<R>(
    R Function() body, {
    KeyStroke Function()? readKey,
    Terminal Function()? createTerminal,
    Never Function(int code)? exit,
  }) {
    final overrides = _TerminalOverridesScope(readKey, createTerminal, exit);
    return _asyncRunZoned(body, zoneValues: {_token: overrides});
  }

  KeyStroke Function() get readKey => KeyStroke.readKey.parse;

  Terminal Function() get createTerminal => Terminal.new;

  Never exit(int code) => dart_io.exit(code);
}

class _TerminalOverridesScope extends TerminalOverrides {
  _TerminalOverridesScope(this._readKey, this._createTerminal, this._exit);

  final TerminalOverrides? _previous = TerminalOverrides.current;
  final KeyStroke Function()? _readKey;
  final Terminal Function()? _createTerminal;
  final Never Function(int code)? _exit;

  @override
  KeyStroke Function() get readKey {
    return _readKey ?? _previous?.readKey ?? super.readKey;
  }

  @override
  Terminal Function() get createTerminal {
    return _createTerminal ?? _previous?.createTerminal ?? super.createTerminal;
  }

  @override
  Never exit(int code) => (_exit ?? _previous?.exit ?? super.exit)(code);
}
