abstract class MineralState<T> {
  T state;

  MineralState(this.state);

  String get name => runtimeType.toString();
}
