import 'dart:async';

import 'package:mineral/core/api.dart';
import 'package:mineral/core/events.dart';
import 'package:mineral/src/api/collectors/collector.dart';
import 'package:mineral/src/api/messages/partial_message.dart';
import 'package:mineral/src/internal/services/collector_service.dart';
import 'package:mineral_ioc/ioc.dart';

/// The MessageCollector class is part of the Mineral framework and is used to collect messages that match certain criteria.
/// It can be used to implement functionality like message polls or message surveys.
class MessageCollector<T extends PartialMessage> extends Collector  {
  final Map<Snowflake, T> _messages = {};
  StreamSubscription? _subscription;

  final bool Function(T message) filter;

  /// Represents the maximum number of messages to collect.
  final int? max;

  /// Represents the maximum amount of time to collect messages for.
  final Duration? time;

  MessageCollector ({ required this.filter, this.max, this.time }): super(MessageCreateEvent) {
    ioc.use<CollectorService>().subscribe(this);
  }

  /// It starts listening to the [MessageCreateEvent] and collects messages that match the filter criteria.
  ///
  /// If max messages have been collected, it cancels the subscription, unsubscribes the collector from the CollectorService, and returns a future containing the collected messages.
  /// ```dart
  /// final collector = MessageCollector<Message>(
  ///   handle: (message) => !message.author.member.isBot,
  ///   max: 2,
  ///   time: Duration(seconds: 10)
  /// );
  ///
  /// final Map<Snowflake, T> messages = await collector.collect();
  /// ```
  @override
  Future<Map<Snowflake, T>> collect () async {
    final completer = Completer<Map<Snowflake, T>>();
    _subscription = controller.stream.listen((message) async {
      if (filter(message)) {
        _messages.putIfAbsent(message.id, () => message);
      }

      if (_messages.length == max) {
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