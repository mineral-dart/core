import 'dart:async';

import 'package:mineral/core/api.dart';
import 'package:mineral/core/events.dart';
import 'package:mineral/src/api/collectors/collector.dart';
import 'package:mineral/src/internal/services/collector_service.dart';
import 'package:mineral_ioc/ioc.dart';

class MessageCollector extends Collector  {
  final Map<Snowflake, Message> _messages = {};
  StreamSubscription? subscription;

  final bool Function(Message message) _filter;
  final int? _max;
  final Duration? _time;

  MessageCollector (this._filter, this._max, this._time): super(MessageCreateEvent) {
    ioc.use<CollectorService>().subscribe(this);
  }

  Duration? get time => _time;

  @override
  Future<dynamic> collect () async {
    final completer = Completer();
    subscription = controller.stream.listen((message) async {
      if (_filter(message)) {
        _messages.putIfAbsent(message.id, () => message);
      }

      if (_messages.length == _max) {
        await _unsubscribe();
        completer.complete(_messages);
      }
    });

    return completer.future;
  }

  Future<void> _unsubscribe () async {
    ioc.use<CollectorService>().unsubscribe(this);
    await subscription?.cancel();
  }
}