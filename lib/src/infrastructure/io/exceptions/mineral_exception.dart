abstract class MineralException implements Exception {
  final String message;

  MineralException(this.message);

  @override
  String toString() => '${runtimeType}: $message';
}
