import 'dart:mirrors';

import 'package:mineral/core.dart';

class EventManager {
  final Collection<Events, List<Object>> _events = Collection();

  EventManager add (Object object) {
    Events event = reflect(object).type.metadata.first.reflectee.event;

    if (_events.containsKey(event)) {
      List<Object>? events = _events.get(event);
      events?.add(object);
    } else {
      _events.putIfAbsent(event, () => [object]);
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

enum Events {
  ready('ready'),
  guildCreate('create::guild'),
  presenceUpdate('update::presence'),

  messageCreate('create::message'),
  messageUpdate('update::message'),
  messageDelete('delete::message'),

  channelCreate('create::channel'),
  channelUpdate('update::channel'),
  channelDelete('delete::channel'),

  memberUpdate('update::member'),
  memberRolesUpdate('update::roles-member'),
  acceptRules('accept::rules');

  final String event;
  const Events(this.event);

  @override
  String toString() => event;
}
