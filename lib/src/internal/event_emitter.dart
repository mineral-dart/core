typedef EventCallback<T> = void Function(T context);
typedef CallbackCollection<T> = Set<EventCallback<T>>;

class EventEmitter<T> {
  final Map<String, CallbackCollection<T>> _listeners = <String, CallbackCollection<T>>{};

  Future<void> on (String event, EventCallback<T> callback) async {
    if (_listeners.containsKey(event)) {
      _listeners[event]?.add((args) => callback);
    } else {
      CallbackCollection<T> callbacks = {};
      callbacks.add(callback);

      _listeners.putIfAbsent(event, () => callbacks);
    }
  }

  void emit (String event, Object? args) {
    if (_listeners.containsKey(event)) {
      CallbackCollection<T>? collection = _listeners[event];

      collection?.forEach((callback) {
        callback.call(args as T);
      });
    }
  }
}
