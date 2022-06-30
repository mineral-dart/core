import 'package:mineral/api.dart';
import 'package:mineral/src/api/managers/channel_manager.dart';
import 'package:mineral/src/api/managers/member_manager.dart';

import 'package:collection/collection.dart';

enum ScheduledEventStatus {
  scheduled(1),
  active(2),
  completed(3),
  canceled(4);

  final int value;
  const ScheduledEventStatus(this.value);
}

enum ScheduledEventEntityType {
  stageInstance(1),
  voice(2),
  external(3);

  final int value;
  const ScheduledEventEntityType(this.value);
}

class GuildScheduledEvent {
  Snowflake id;
  //Guild guild;
  Channel? channel;
  GuildMember? creator;
  String name;
  String? description;
  DateTime startTime;
  DateTime? endTime;
  ScheduledEventStatus status;
  ScheduledEventEntityType entityType;
  Snowflake? entityId;
  int? subscribers;
  String? image;

  GuildScheduledEvent({
      required this.id,
      //required this.guild,
      required this.channel,
      required this.creator,
      required this.name,
      required this.description,
      required this.startTime,
      required this.endTime,
      required this.status,
      required this.entityType,
      required this.entityId,
      required this.subscribers,
      required this.image
  });

  factory GuildScheduledEvent.from({ required ChannelManager channelManager, required MemberManager memberManager, required payload }) {
    return GuildScheduledEvent(
      id: payload['id'],
      //guild: guild,
      channel: payload['channel_id'] != null ? channelManager.cache.get(payload['channel_id']) : null,
      creator: payload['creator_id'] != null ? memberManager.cache.get(payload['creator_id']) : null,
      name: payload['name'],
      description: payload['description'],
      startTime: DateTime.parse(payload['scheduled_start_time']),
      endTime: payload['scheduled_end_time'] != null ? DateTime.parse(payload['scheduled_end_time']) : null,
      status: ScheduledEventStatus.values.firstWhere((element) => element.value == payload['status']),
      entityType: ScheduledEventEntityType.values.firstWhere((element) => element.value == payload['entity_type']),
      entityId: payload['entity_id'],
      subscribers: payload['user_count'],
      image: payload['image']
    );
  }
}