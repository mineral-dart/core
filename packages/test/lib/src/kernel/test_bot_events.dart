import '../handlers/listener.dart';
import '../simulators/registries.dart';

/// Test-friendly listener registry exposed via `bot.events`.
final class BotEvents {
  final ListenerRegistry _registry;

  BotEvents(this._registry);

  /// Register any test-friendly listener (`OnMemberJoinListener`,
  /// `OnCommandListener`, `OnButtonListener`, `OnModalSubmitListener`).
  void register(TestBotListener listener) => _registry.register(listener);
}
