import 'dart:async';

abstract class Collector {
  final StreamController controller = StreamController();
  final Type _event;

  Collector(this._event);

  Type get event => _event;

  Future<dynamic> collect ();
}