import 'package:mineral/framework.dart';
import 'package:mineral/src/exceptions/already_exist_exception.dart';
import 'package:mineral/src/exceptions/not_exist_exception.dart';
import 'package:mineral_ioc/ioc.dart';

abstract class MineralStateContract {
  T use<T> ();
}

class StateManager extends MineralService implements MineralStateContract {
  final Map<Type, MineralState> _states = {};

  StateManager(): super(inject: true);

  Map<Type, MineralState> get states => _states;

  @override
  T use<T> () {
    if (!_states.containsKey(T)) {
      throw NotExistException('The shared state named $T does not exist on your project.');
    }

    return _states[T] as T;
  }

  void register (List<MineralState> mineralStates) {
    for (final store in mineralStates) {
      if (_states.containsKey(store.runtimeType)) {
        throw AlreadyExistException('A shared state named ${store.name} already exists.');
      }

      _states.putIfAbsent(store.runtimeType, () => store);
    }
  }
}