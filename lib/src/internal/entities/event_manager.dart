import 'dart:mirrors';

import 'package:mineral/api.dart';
import 'package:mineral/src/internal/entities/store_manager.dart';

class EventManager {
  final Map<Events, List<Map<String, dynamic>>> _events = {};

  Map<Events, List<Map<String, dynamic>>> getRegisteredEvents () => _events;

  EventManager add (MineralEvent mineralEvent) {
    Event eventDecorator = reflect(mineralEvent).type.metadata.first.reflectee;
    Events event = eventDecorator.event;
    String? customId = eventDecorator.customId;

    Map<String, dynamic> eventEntity = {
      'mineralEvent': mineralEvent,
      'customId': customId,
    };

    if (_events.containsKey(event)) {
      List<Map<String, dynamic>>? events = _events.get(event);
      events?.add(eventEntity);
    } else {
      _events.putIfAbsent(event, () => [eventEntity]);
    }

    return this;
  }

  void emit ({ required Events event, String? customId, List<dynamic>? params }) {
    List<Map<String, dynamic>>? events = _events.get(event);

    if (events != null) {
      for (Map<String, dynamic> event in events) {
        print("customId ${customId != null} → ${event['customId'] == null}");
        if (customId != null) {
          if (customId == event['customId']) {
            reflect(event['mineralEvent']).invoke(Symbol('handle'), params ?? []);
          }
        } else {
          if (event['customId'] == null) {
            reflect(event['mineralEvent']).invoke(Symbol('handle'), params ?? []);
          }
        }
      }
    }
  }
}

class Event {
  final Events event;
  final String? customId;

  const Event(this.event, { this.customId });
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

  commandCreate('create::commandInteraction'),
  buttonCreate('create::buttonInteraction');

  final String event;
  const Events(this.event);

  @override
  String toString() => event;
}
