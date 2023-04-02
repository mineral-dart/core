import 'package:collection/collection.dart';
import 'package:mineral/core/api.dart';
import 'package:mineral/core/events.dart';
import 'package:mineral/framework.dart';
import 'package:mineral/src/api/guilds/activities/game_activity.dart';
import 'package:mineral/src/api/guilds/activities/guild_member_activity.dart';
import 'package:mineral/src/api/guilds/activities/streaming_activity.dart';
import 'package:mineral/src/api/guilds/client_status_bucket.dart';
import 'package:mineral/src/api/guilds/guild_member_presence.dart';
import 'package:mineral/src/internal/mixins/container.dart';
import 'package:mineral/src/internal/services/event_service.dart';
import 'package:mineral/src/internal/websockets/websocket_packet.dart';
import 'package:mineral/src/internal/websockets/websocket_response.dart';

import '../../../api/guilds/activities/custom_activity.dart';

class PresenceUpdatePacket with Container implements WebsocketPacket {
  @override
  Future<void> handle(WebsocketResponse websocketResponse) async {
    EventService eventService = container.use<EventService>();
    MineralClient client = container.use<MineralClient>();

    dynamic payload = websocketResponse.payload;

    if (payload['guild_id'] == null) {
      return;
    }

    Guild? guild = client.guilds.cache.getOrFail(payload['guild_id']);

    GuildMember beforeMember = guild.members.cache.getOrFail(payload['user']['id']).clone();
    GuildMember afterMember = guild.members.cache.getOrFail(payload['user']['id']);

    final List<GuildMemberActivity> activities = List.from(payload['activities']).map((activity) {
      final activityType = ActivityType.values.firstWhereOrNull((type) => activity['type'] == type.value);

      switch (activityType) {
        case ActivityType.custom:
          return CustomActivity.from(payload['guild_id'], activity);
        case ActivityType.game:
          return GameActivity.from(payload['guild_id'], activity);
        case ActivityType.streaming:
          return StreamingActivity.from(payload['guild_id'], activity);
        default:
          return GuildMemberActivity(
            ActivityType.values.firstWhere((type) => type.value == activity['type']),
            activity['name']
          );
      }
    }).toList();


    afterMember.presence = GuildMemberPresence(
      payload['guild_id'],
      payload['status'],
      payload['premium_since'],
      ClientStatusBucket(
        payload['client_status']?['desktop'],
        payload['client_status']?['web'],
        payload['client_status']?['mobile'],
      ),
      activities
    );


    // afterMember?.user.status = Status.from(guild: guild!, payload: payload);

    eventService.controller.add(PresenceUpdateEvent(beforeMember, afterMember));
  }
}
