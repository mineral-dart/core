import 'dart:convert';
import 'dart:mirrors';

import 'package:mineral/api.dart';
import 'package:mineral/core.dart';
import 'package:mineral/src/api/interactions/button_interaction.dart';
import 'package:mineral/src/internal/entities/command_manager.dart';
import 'package:mineral/src/internal/entities/event_manager.dart';
import 'package:mineral/src/internal/websockets/websocket_packet.dart';
import 'package:mineral/src/internal/websockets/websocket_response.dart';

class InteractionCreate implements WebsocketPacket {
  @override
  PacketType packetType = PacketType.interactionCreate;

  @override
  Future<void> handle(WebsocketResponse websocketResponse) async {
    MineralClient client = ioc.singleton(ioc.services.client);

    dynamic payload = websocketResponse.payload;
    print(jsonEncode(payload));

    Guild? guild = client.guilds.cache.get(payload['guild_id']);
    GuildMember? member = guild?.members.cache.get(payload['member']['user']['id']);


    if (payload['type'] == InteractionType.applicationCommand.value) {
      _executeCommandInteraction(guild!, member!, payload);
    }

    if (payload['type'] == InteractionType.messageComponent.value) {
      _executeButtonInteraction(guild!, member!, payload);
    }
  }

  _executeCommandInteraction (Guild guild, GuildMember member, dynamic payload) {
    CommandManager manager = ioc.singleton(ioc.services.command);
    CommandInteraction commandInteraction = CommandInteraction.from(user: member.user, payload: payload);
    commandInteraction.guild = guild;

    String identifier = commandInteraction.identifier;

    walk (List<dynamic> objects) {
      for (dynamic object in objects) {
        if (object['type'] == 1 || object['type'] == 2) {
          identifier += ".${object['name']}";
          if (object['options'] != null) {
            walk(object['options']);
          }
        } else {
          commandInteraction.data.putIfAbsent(object['name'], () => object);
        }
      }
    }

    if (payload['data']['options'] != null) {
      walk(payload['data']['options']);
    }

    dynamic handle = manager.getHandler(identifier);
    reflect(handle['commandClass']).invoke(handle['symbol'], [commandInteraction]);
  }

  _executeButtonInteraction (Guild guild, GuildMember member, dynamic payload) {
    EventManager manager = ioc.singleton(ioc.services.event);
    TextBasedChannel? channel = guild.channels.cache.get(payload['channel_id']);
    Message? message = channel?.messages.cache.get(payload['message']['id']);

    ButtonInteraction buttonInteraction = ButtonInteraction.from(
      user: member.user,
      message: message,
      payload: payload
    );

    buttonInteraction.guild = guild;

    manager.emit(
      event: Events.buttonCreate,
      customId: buttonInteraction.customId,
      params: [buttonInteraction]
    );

    manager.emit(
      event: Events.buttonCreate,
      params: [buttonInteraction]
    );
  }
}
