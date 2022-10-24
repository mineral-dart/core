import 'package:mineral/core.dart';
import 'package:mineral/src/internal/websockets/packets/auto_moderation_rule_create.dart';
import 'package:mineral/src/internal/websockets/packets/auto_moderation_rule_delete.dart';

import 'package:mineral/src/internal/websockets/packets/channel_create.dart';
import 'package:mineral/src/internal/websockets/packets/channel_delete.dart';
import 'package:mineral/src/internal/websockets/packets/channel_update.dart';
import 'package:mineral/src/internal/websockets/packets/guild_create_packet.dart';
import 'package:mineral/src/internal/websockets/packets/guild_integrations_update.dart';
import 'package:mineral/src/internal/websockets/packets/guild_member_add.dart';
import 'package:mineral/src/internal/websockets/packets/guild_member_remove.dart';
import 'package:mineral/src/internal/websockets/packets/guild_member_update.dart';
import 'package:mineral/src/internal/websockets/packets/guild_scheduled_event_create.dart';
import 'package:mineral/src/internal/websockets/packets/guild_scheduled_event_delete.dart';
import 'package:mineral/src/internal/websockets/packets/guild_scheduled_event_update.dart';
import 'package:mineral/src/internal/websockets/packets/guild_scheduled_event_user_add.dart';
import 'package:mineral/src/internal/websockets/packets/guild_scheduled_event_user_remove.dart';
import 'package:mineral/src/internal/websockets/packets/guild_update.dart';
import 'package:mineral/src/internal/websockets/packets/interaction_create.dart';
import 'package:mineral/src/internal/websockets/packets/member_join_request.dart';
import 'package:mineral/src/internal/websockets/packets/message_create.dart';
import 'package:mineral/src/internal/websockets/packets/message_delete.dart';
import 'package:mineral/src/internal/websockets/packets/message_update.dart';
import 'package:mineral/src/internal/websockets/packets/presence_update.dart';
import 'package:mineral/src/internal/websockets/packets/ready_packet.dart';
import 'package:mineral/src/internal/websockets/packets/resumed_packet.dart';
import 'package:mineral/src/internal/websockets/packets/voice_state_update.dart';
import 'package:mineral/src/internal/websockets/packets/webhook_update.dart';
import 'package:mineral/src/internal/websockets/websocket_packet.dart';
import 'package:mineral/src/internal/websockets/websocket_response.dart';

import 'package:collection/collection.dart';

class WebsocketDispatcher {
  final Map<PacketType, List<WebsocketPacket>> _packets = {};

  WebsocketDispatcher() {
    register(PacketType.ready, ReadyPacket());
    register(PacketType.resumed, ResumedPacket());
    register(PacketType.guildCreate, GuildCreatePacket());
    register(PacketType.guildUpdate, GuildUpdate());
    register(PacketType.presenceUpdate, PresenceUpdate());
    register(PacketType.messageDelete, MessageDelete());
    register(PacketType.messageCreate, MessageCreate());
    register(PacketType.messageUpdate, MessageUpdate());
    register(PacketType.channelCreate, ChannelCreate());
    register(PacketType.channelDelete, ChannelDelete());
    register(PacketType.channelUpdate, ChannelUpdate());
    register(PacketType.memberUpdate, GuildMemberUpdate());
    register(PacketType.memberRemove, GuildMemberRemove());
    register(PacketType.memberAdd, GuildMemberAdd());
    register(PacketType.memberJoinRequest, MemberJoinRequest());
    register(PacketType.interactionCreate, InteractionCreate());
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
      for (var packet in packets) {
        await packet.handle(websocketResponse);
      }
    }
  }
}
