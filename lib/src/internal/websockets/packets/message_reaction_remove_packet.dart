import 'package:mineral/core/api.dart';
import 'package:mineral/core/builders.dart';
import 'package:mineral/core/events.dart';
import 'package:mineral/framework.dart';
import 'package:mineral/src/api/emoji.dart';
import 'package:mineral/src/internal/services/event_service.dart';
import 'package:mineral/src/internal/websockets/websocket_packet.dart';
import 'package:mineral/src/internal/websockets/websocket_response.dart';
import 'package:mineral_ioc/ioc.dart';

class MessageReactionRemovePacket implements WebsocketPacket {
  @override
  Future<void> handle (WebsocketResponse websocketResponse) async {
    EventService eventService = ioc.use<EventService>();
    MineralClient client = ioc.use<MineralClient>();

    dynamic payload = websocketResponse.payload;

    Guild? guild = client.guilds.cache.get(payload['guild_id']);
    TextBasedChannel? channel = await guild?.channels.resolve(payload['channel_id']) as TextBasedChannel?;
    Message? message = await channel?.messages.resolve(payload['message_id']);
    User user = await client.users.resolve(payload['user_id']);
    GuildMember? member = await guild?.members.resolve(payload['user_id']);

    EmojiBuilder emoji = EmojiBuilder(PartialEmoji(
      payload['emoji']['id'] ?? payload['emoji']['name'],
      payload['emoji']['name'],
      payload['emoji']['animated'] ?? false,
    ));

    if (channel != null && message != null) {
      eventService.controller.add(MessageReactionRemoveEvent(
        guild,
        channel,
        message,
        user,
        member,
        emoji,
      ));
    }
  }
}
