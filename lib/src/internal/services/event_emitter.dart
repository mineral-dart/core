typedef EventCallback<T> = void Function(T context);
typedef CallbackMap<T> = Set<EventCallback<T>>;

class EventEmitter<T> {
  final Map<String, CallbackMap<T>> _listeners = <String, CallbackMap<T>>{};

  void on (String event, EventCallback<T> callback) {
    if (_listeners.containsKey(event)) {
      _listeners[event]?.add((args) => callback);
    } else {
      CallbackMap<T> callbacks = {};
      callbacks.add(callback);

      _listeners.putIfAbsent(event, () => callbacks);
    }
  }

  void emit (String event, Object? args) {
    if (_listeners.containsKey(event)) {
      CallbackMap<T>? callbacks = _listeners[event];

      callbacks?.forEach((callback) {
        callback.call(args as T);
      });
    }
  }
}
