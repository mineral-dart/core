import 'package:mineral/internal/factories/states/contracts/state_contract.dart';
import 'package:mineral/internal/factories/states/contracts/state_factory_contract.dart';
import 'package:mineral/internal/fold/container.dart';
import 'package:mineral/internal/fold/injectable.dart';

final class StateFactory extends Injectable implements StateFactoryContract {
  final List<StateContract> states = [];

  StateFactory();

  void register (StateContract Function() state) {
    states.add(state());
  }

  void registerMany (List<StateContract Function()> states) {
    for (final state in states) {
      register(state);
    }
  }

  StateContract find<T extends StateContract>() => states.whereType<T>().first;

  factory StateFactory.singleton() => container.use('Mineral/Factories/State');
}