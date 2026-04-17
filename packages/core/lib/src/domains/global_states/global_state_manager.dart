import 'package:mineral/src/domains/global_states/global_state.dart';

abstract interface class GlobalStateManagerContract {
  void register<T>(T state);
}

abstract interface class GlobalStateService {
  T read<T extends GlobalState>();
}

final class GlobalStateManager
    implements GlobalStateManagerContract, GlobalStateService {
  final Map<Type, dynamic> _providers = {};

  @override
  void register<T>(T state) => _providers[T] = state;

  @override
  T read<T extends GlobalState>() {
    final value = _providers[T];
    if (value == null) {
      throw StateError(
        'GlobalState of type $T has not been registered. '
        'Call register<$T>() before read<$T>().',
      );
    }
    return value as T;
  }
}
