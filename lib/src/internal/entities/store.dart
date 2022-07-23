import 'package:mineral/core.dart';

class Store {
  final String type = 'store';
  final String name;

  const Store(this.name);
}

abstract class MineralStore {
  late Environment environment;
  late dynamic state;
}
