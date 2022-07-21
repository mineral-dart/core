import 'dart:mirrors';

import 'package:mineral/api.dart';
import 'package:mineral/core.dart';
import 'package:mineral/src/api/interactions/interaction.dart';
import 'package:mineral/src/api/managers/voice_manager.dart';
import 'package:mineral/src/internal/managers/store_manager.dart';

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
  late Environment environment;
}

enum Events {
  ready('ready', { 'client': MineralClient }),
  guildCreate('create::guild', { 'guild': Guild }),
  guildUpdate('update::guild', { 'before': Guild, 'after': Guild }),
  presenceUpdate('update::presence', { 'before': GuildMember, 'after': GuildMember }),

  moderationRuleCreate('create::moderation-rule', { 'rule': ModerationRule }),
  moderationRuleUpdate('update::moderation-rule', { 'before': ModerationRule, 'after': ModerationRule }),
  moderationRuleDelete('delete::moderation-rule', { 'rule': ModerationRule }),

  guildScheduledEventCreate('create::scheduled-event', { 'event': GuildScheduledEvent }),
  guildScheduledEventDelete('delete::scheduled-event', { 'event': GuildScheduledEvent }),
  guildScheduledEventUpdate('update::scheduled-event', { 'before': GuildScheduledEvent, 'after': GuildScheduledEvent }),
  guildScheduledEventUserAdd('user-add::scheduled-event', { 'event': GuildScheduledEvent, 'user': User, 'member': 'GuildMember?' }),
  guildScheduledEventUserRemove('user-remove::scheduled-event', { 'event': GuildScheduledEvent, 'user': User, 'member': 'GuildMember?' }),

  messageCreate('create::message', { 'message': Message }),
  messageUpdate('update::message', { 'before': Message, 'after': Message }),
  messageDelete('delete::message', { 'message': Message }),

  channelCreate('create::channel', { 'channel': Channel }),
  channelUpdate('update::channel', { 'before': Channel, 'after': Channel }),
  channelDelete('delete::channel', { 'channel': Channel }),

  memberJoin('join::member', { 'member': GuildMember }),
  memberUpdate('update::member', { 'before': GuildMember, 'after': GuildMember }),
  memberLeave('leave::member', { 'member': GuildMember }),
  memberRolesUpdate('update::roles-member', { 'before': Role, 'after': Role }),
  acceptRules('accept::rules', { 'member': GuildMember }),

  interactionCreate('create::interaction', { 'interaction': Interaction }),
  commandCreate('create::commandInteraction', { 'interaction': CommandInteraction }),
  buttonCreate('create::buttonInteraction', { 'interaction': ButtonInteraction }),
  modalCreate('create::modalInteraction', { 'interaction': ModalInteraction }),
  selectMenuCreate('create::selectMenuInteraction', { 'interaction': SelectMenuInteraction }),

  voiceStateUpdate('update::voice', { 'before': VoiceManager, 'after': VoiceManager }),
  voiceConnect('connect::voice', { 'member': GuildMember, 'before': 'VoiceChannel?', 'after': VoiceChannel }),
  voiceDisconnect('disconnect::voice', { 'member': GuildMember, 'channel': VoiceChannel }),
  memberMuted('mute::voice', { 'member': GuildMember }),
  memberUnMuted('unmute::voice', { 'member': GuildMember }),
  memberDeaf('deaf::voice', { 'member': GuildMember }),
  memberUnDeaf('undeaf::voice', { 'member': GuildMember }),
  memberSelfMuted('self::mute::voice', { 'member': GuildMember }),
  memberSelfUnMuted('self::unmute::voice', { 'member': GuildMember }),
  memberSelfDeaf('self::deaf::voice', { 'member': GuildMember }),
  memberSelfUnDeaf('self::undeaf::voice', { 'member': GuildMember });

  final String event;
  final Map<String, dynamic> params;
  const Events(this.event, this.params);
}
