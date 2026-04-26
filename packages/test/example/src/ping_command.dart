import 'package:mineral_test/mineral_test.dart';

/// `/ping` — replies with `pong`.
final class PingListener extends OnCommandListener {
  @override
  String get command => 'ping';

  @override
  Future<void> handle(CommandInvocation invocation) async {
    await TestInteractionResponder.reply(
      interactionId: invocation.interactionId,
      token: invocation.token,
      content: 'pong',
    );
  }
}

/// `/echo message:<value>` — replies with the option's value.
final class EchoListener extends OnCommandListener {
  @override
  String get command => 'echo';

  @override
  Future<void> handle(CommandInvocation invocation) async {
    final message = invocation.options['message'] as String? ?? '';
    await TestInteractionResponder.reply(
      interactionId: invocation.interactionId,
      token: invocation.token,
      content: message,
    );
  }
}

/// `/boom` — always throws. Used to demonstrate handler-error capture.
final class BoomListener extends OnCommandListener {
  @override
  String get command => 'boom';

  @override
  Future<void> handle(CommandInvocation invocation) async {
    throw StateError('boom!');
  }
}
