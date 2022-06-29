import 'dart:mirrors';

import 'package:mineral/api.dart';
import 'package:mineral/src/internal/entities/store_manager.dart';

class EventManager {
  final Map<Events, List<MineralEvent>> _events = {};

  Map<Events, List<MineralEvent>> getRegisteredEvents () => _events;

  EventManager add (MineralEvent mineralEvent) {
    Events event = reflect(mineralEvent).type.metadata.first.reflectee.event;
    if (_events.containsKey(event)) {
      List<MineralEvent>? events = _events.get(event);
      events?.add(mineralEvent);
    } else {
      _events.putIfAbsent(event, () => [mineralEvent]);
    }

    return this;
  }

  void emit (Events event, [params]) {
    List<Object>? events = _events.get(event);

    if (events != null) {
      for (Object event in events) {
        reflect(event).invoke(Symbol('handle'), params);
      }
    }
  }
}

class Event {
  final String type = 'event';
  final Events event;

  const Event(this.event);
}

abstract class MineralEvent {
  late StoreManager stores;
  late MineralClient client;
}

enum Events {
  ready('ready'),
  guildCreate('create::guild'),
  guildUpdate('update::guild'),
  presenceUpdate('update::presence'),

  moderationRuleCreate('create::moderation-rule'),
  moderationRuleUpdate('update::moderation-rule'),
  moderationRuleDelete('delete::moderation-rule'),

  messageCreate('create::message'),
  messageUpdate('update::message'),
  messageDelete('delete::message'),

  channelCreate('create::channel'),
  channelUpdate('update::channel'),
  channelDelete('delete::channel'),

  memberUpdate('update::member'),
  memberRolesUpdate('update::roles-member'),
  acceptRules('accept::rules'),

  commandCreate('create::commandInteraction');

  final String event;
  const Events(this.event);

  @override
  String toString() => event;
}
