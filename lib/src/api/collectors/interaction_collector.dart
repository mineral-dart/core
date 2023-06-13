import 'dart:async';

import 'package:mineral/core/events.dart';
import 'package:mineral/framework.dart';
import 'package:mineral/src/api/collectors/collector.dart';
import 'package:mineral/src/internal/services/collector_service.dart';
import 'package:mineral_ioc/ioc.dart';

/// The MessageCollector class is part of the Mineral framework and is used to collect messages that match certain criteria.
/// It can be used to implement functionality like message polls or message surveys.
class InteractionCollector<T extends Event> extends Collector  {
  final String _customId;
  StreamSubscription? _subscription;

  InteractionCollector (this._customId): super(T) {
    ioc.use<CollectorService>().subscribe(this);
  }

  @override
  Future<T> collect () async {
    final completer = Completer<T>();
    _subscription = controller.stream.listen((event) async {
      if (event is ButtonCreateEvent && event.interaction.customId == _customId) {
        await _unsubscribe();
        completer.complete(event as T);
      }

      if (event is DynamicMenuCreateEvent && event.interaction.customId == _customId) {
        await _unsubscribe();
        completer.complete(event as T);
      }

      if (event is ChannelMenuCreateEvent && event.interaction.customId == _customId) {
        await _unsubscribe();
        completer.complete(event as T);
      }

      if (event is UserMenuCreateEvent && event.interaction.customId == _customId) {
        await _unsubscribe();
        completer.complete(event as T);
      }

      if (event is MentionableMenuCreateEvent && event.interaction.customId == _customId) {
        await _unsubscribe();
        completer.complete(event as T);
      }

      if (event is RoleMenuCreateEvent && event.interaction.customId == _customId) {
        await _unsubscribe();
        completer.complete(event as T);
      }

      if (event is ModalCreateEvent && event.interaction.customId == _customId) {
        await _unsubscribe();
        completer.complete(event as T);
      }
    });

    return completer.future;
  }

  Future<void> _unsubscribe () async {
    ioc.use<CollectorService>().unsubscribe(this);
    await _subscription?.cancel();
  }
}