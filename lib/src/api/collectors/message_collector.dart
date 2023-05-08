import 'dart:async';

import 'package:mineral/core/api.dart';
import 'package:mineral/core/events.dart';
import 'package:mineral/src/api/collectors/collector.dart';
import 'package:mineral/src/internal/services/collector_service.dart';
import 'package:mineral_ioc/ioc.dart';

/// The MessageCollector class is part of the Mineral framework and is used to collect messages that match certain criteria.
/// It can be used to implement functionality like message polls or message surveys.
class MessageCollector extends Collector  {
  final Map<Snowflake, Message> _messages = {};
  StreamSubscription? _subscription;

  final bool Function(Message message) _filter;
  final int? _max;
  final Duration? _time;

  MessageCollector (this._filter, this._max, this._time): super(MessageCreateEvent) {
    ioc.use<CollectorService>().subscribe(this);
  }

  /// Represents the maximum number of messages to collect.
  int? get max => _max;

  /// /// Represents the maximum amount of time to collect messages for.
  Duration? get time => _time;

  /// It starts listening to the [MessageCreateEvent] and collects messages that match the filter criteria.
  ///
  /// If max messages have been collected, it cancels the subscription, unsubscribes the collector from the CollectorService, and returns a future containing the collected messages.
  @override
  Future<dynamic> collect () async {
    final completer = Completer();
    _subscription = controller.stream.listen((message) async {
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

  /// Unsubscribes the collector from the [MessageCollector] and cancels the subscription.
  Future<void> _unsubscribe () async {
    ioc.use<CollectorService>().unsubscribe(this);
    await _subscription?.cancel();
  }
}