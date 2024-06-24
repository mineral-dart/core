import 'dart:async';
import 'package:mineral/infrastructure/interaction/interaction_manager.dart';
import 'package:mineral/infrastructure/interaction/interaction_type.dart';

abstract class InteractionDispatcherContract {
  Future<void> dispatch(Map<String, dynamic> data);
}

final class InteractionDispatcher implements InteractionDispatcherContract {
  final InteractionManagerContract _interactionManager;

  InteractionDispatcher(this._interactionManager);

  @override
  Future<void> dispatch(Map<String, dynamic> data) async {
    final interactionType = InteractionType.values.firstWhere((e) => e.value == data['type']);

    switch (interactionType) {
      case InteractionType.applicationCommand:
        await _handleCommand(data);
      default:
        throw Exception('Unknown interaction type: ${data['type']}');
    }
  }

  Future<void> _handleCommand(Map<String, dynamic> data) async {
    final (String, FutureOr<void> Function()) command = _interactionManager.commandsHandler.firstWhere((command) => command.$1 == data['data']['name']);

    switch (data['data']['type']) {

    }

    await Function.apply(command.$2, []);
  }
}