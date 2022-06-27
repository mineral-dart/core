import 'package:mineral/api.dart';
import 'package:mineral/src/internal/entities/file_entity.dart';
import 'package:mineral/src/internal/entities/store_manager.dart';

class EventManager {
  final Map<Events, List<FileEntity>> _events = {};

  Map<Events, List<FileEntity>> get events => _events;

  EventManager add (FileEntity fileEntity) {
    Events event = fileEntity.instanceMirror.type.metadata.first.reflectee.event;
    if (_events.containsKey(event)) {
      List<FileEntity>? events = _events[event];
      events?.add(fileEntity);
    } else {
      _events.putIfAbsent(event, () => [fileEntity]);
    }
    return this;
  }

  EventManager addAll (List<FileEntity> fileEntities) {
    for (FileEntity fileEntity in fileEntities) {
      Events event = fileEntity.instanceMirror.type.metadata.first.reflectee.event;
      if (_events.containsKey(event)) {
        List<FileEntity>? events = _events[event];
        events?.add(fileEntity);
      } else {
        _events.putIfAbsent(event, () => [fileEntity]);
      }
    }
    return this;
  }

  void emit (Events event, [params]) {
    List<FileEntity>? events = _events[event];

    if (events != null) {
      for (FileEntity fileEntity in events) {
        fileEntity.instanceMirror.invoke(Symbol('handle'), params);
      }
    }
  }
}

class Event {
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
