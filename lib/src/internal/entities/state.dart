import 'package:mineral_contract/mineral_contract.dart';

abstract class MineralState<T> implements MineralStateContract<T> {
  T state;

  MineralState(this.state);

  String get name => runtimeType.toString();
}
