import 'package:collection/collection.dart';
import 'package:mineral/core.dart';
import 'package:mineral/src/internal/websockets/packets/auto_moderation_rule_create.dart';
import 'package:mineral/src/internal/websockets/packets/auto_moderation_rule_delete.dart';
import 'package:mineral/src/internal/websockets/packets/channel_create_packet.dart';
import 'package:mineral/src/internal/websockets/packets/channel_delete_packet.dart';
import 'package:mineral/src/internal/websockets/packets/channel_update_packet.dart';
import 'package:mineral/src/internal/websockets/packets/guild_create_packet.dart';
import 'package:mineral/src/internal/websockets/packets/guild_integrations_update.dart';
import 'package:mineral/src/internal/websockets/packets/guild_remove_packet.dart';
import 'package:mineral/src/internal/websockets/packets/guild_scheduled_event_create.dart';
import 'package:mineral/src/internal/websockets/packets/guild_scheduled_event_delete.dart';
import 'package:mineral/src/internal/websockets/packets/guild_scheduled_event_update.dart';
import 'package:mineral/src/internal/websockets/packets/guild_scheduled_event_user_add.dart';
import 'package:mineral/src/internal/websockets/packets/guild_scheduled_event_user_remove.dart';
import 'package:mineral/src/internal/websockets/packets/guild_update_packet.dart';
import 'package:mineral/src/internal/websockets/packets/interaction_create_packet.dart';
import 'package:mineral/src/internal/websockets/packets/member_join_packet.dart';
import 'package:mineral/src/internal/websockets/packets/member_join_request.dart';
import 'package:mineral/src/internal/websockets/packets/member_remove_packet.dart';
import 'package:mineral/src/internal/websockets/packets/member_update_packet.dart';
import 'package:mineral/src/internal/websockets/packets/message_create_packet.dart';
import 'package:mineral/src/internal/websockets/packets/message_delete_packet.dart';
import 'package:mineral/src/internal/websockets/packets/message_update_packet.dart';
import 'package:mineral/src/internal/websockets/packets/presence_update.dart';
import 'package:mineral/src/internal/websockets/packets/ready_packet.dart';
import 'package:mineral/src/internal/websockets/packets/resumed_packet.dart';
import 'package:mineral/src/internal/websockets/packets/voice_state_update.dart';
import 'package:mineral/src/internal/websockets/packets/webhook_update.dart';
import 'package:mineral/src/internal/websockets/websocket_packet.dart';
import 'package:mineral/src/internal/websockets/websocket_response.dart';

class WebsocketDispatcher {
  final Map<PacketType, List<WebsocketPacket>> _packets = {};

  WebsocketDispatcher() {
    register(PacketType.ready, ReadyPacket());
    register(PacketType.resumed, ResumedPacket());
    register(PacketType.guildCreate, GuildCreatePacket());
    register(PacketType.guildUpdate, GuildUpdatePacket());
    register(PacketType.guildDelete, GuildRemovePacket());
    register(PacketType.presenceUpdate, PresenceUpdatePacket());
    register(PacketType.messageDelete, MessageDeletePacket());
    register(PacketType.messageCreate, MessageCreatePacket());
    register(PacketType.messageUpdate, MessageUpdatePacket());
    register(PacketType.channelCreate, ChannelCreatePacket());
    register(PacketType.channelDelete, ChannelDeletePacket());
    register(PacketType.channelUpdate, ChannelUpdatePacket());
    register(PacketType.memberUpdate, MemberUpdatePacket());
    register(PacketType.memberRemove, MemberLeavePacket());
    register(PacketType.memberAdd, MemberJoinPacket());
    register(PacketType.memberJoinRequest, MemberJoinRequest());
    register(PacketType.interactionCreate, InteractionCreatePacket());
    register(PacketType.autoModerationRuleCreate, AutoModerationRuleCreate());
    register(PacketType.autoModerationRuleDelete, AutoModerationRuleDelete());
    register(PacketType.guildScheduledEventCreate, GuildScheduledEventCreate());
    register(PacketType.guildScheduledEventUpdate, GuildScheduledEventUpdate());
    register(PacketType.guildScheduledEventDelete, GuildScheduledEventDelete());
    register(PacketType.guildScheduledEventUserAdd, GuildScheduledEventUserAdd());
    register(PacketType.guildScheduledEventUserRemove, GuildScheduledEventUserRemove());
    register(PacketType.webhookUpdate, WebhookUpdate());
    register(PacketType.guildIntegrationsUpdate, GuildIntegrationsUpdate());
    register(PacketType.voiceStateUpdate, VoiceStateUpdatePacket());
  }

  void register (PacketType type, WebsocketPacket packet) {
    if (_packets.containsKey(type)) {
      List<WebsocketPacket> packets = _packets[type]!;
      packets.add(packet);
    } else {
      _packets.putIfAbsent(type, () => List.filled(1, packet));
    }
  }

  Future<void> dispatch (WebsocketResponse websocketResponse) async {
    PacketType? packet = PacketType.values.firstWhereOrNull((element) => element.toString() == websocketResponse.type);

    if (_packets.containsKey(packet)) {
      List<WebsocketPacket> packets = _packets[packet]!;
      for (final packet in packets) {
        await packet.handle(websocketResponse);
      }
    }
  }
}
