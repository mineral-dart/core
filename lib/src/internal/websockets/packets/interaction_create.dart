import 'dart:convert';
import 'dart:mirrors';

import 'package:http/http.dart';
import 'package:mineral/api.dart';
import 'package:mineral/core.dart';
import 'package:mineral/src/api/components/component.dart';
import 'package:mineral/src/internal/managers/command_manager.dart';
import 'package:mineral/src/internal/managers/context_menu_manager.dart';
import 'package:mineral/src/internal/managers/event_manager.dart';
import 'package:mineral/src/internal/websockets/websocket_packet.dart';
import 'package:mineral/src/internal/websockets/websocket_response.dart';

class InteractionCreate implements WebsocketPacket {
  @override
  PacketType packetType = PacketType.interactionCreate;

  @override
  Future<void> handle(WebsocketResponse websocketResponse) async {
    EventManager manager = ioc.singleton(ioc.services.event);
    MineralClient client = ioc.singleton(ioc.services.client);

    dynamic payload = websocketResponse.payload;

    Guild? guild = client.guilds.cache.get(payload['guild_id']);
    GuildMember? member = guild?.members.cache.get(payload['member']['user']['id']);

    if (payload['type'] == InteractionType.applicationCommand.value && payload['data']['type'] == ApplicationCommandType.chatInput.value) {
      _executeCommandInteraction(guild!, member!, payload);
    }

    if (payload['type'] == InteractionType.applicationCommand.value && payload['data']['type'] == ApplicationCommandType.user.value) {
      _executeContextMenuInteraction(guild!, member!, payload);
    }

    if (payload['type'] == InteractionType.applicationCommand.value && payload['data']['type'] == ApplicationCommandType.message.value) {
      _executeContextMenuInteraction(guild!, member!, payload);
    }

    if (payload['type'] == InteractionType.messageComponent.value && payload['data']['component_type'] == ComponentType.button.value) {
      _executeButtonInteraction(guild!, member!, payload);
    }

    if (payload['type'] == InteractionType.messageComponent.value && payload['data']['component_type'] == ComponentType.selectMenu.value) {
      _executeSelectMenuInteraction(guild!, member!, payload);
    }

    if (payload['type'] == InteractionType.modalSubmit.value) {
      _executeModalInteraction(guild!, member!, payload);
    }

    if (member != null) {
      final Interaction interaction = Interaction.from(user: member.user, payload: payload, guild: guild);

      manager.emit(
        event: Events.interactionCreate,
        params: [interaction]
      );
    }
  }

  _executeCommandInteraction (Guild guild, GuildMember member, dynamic payload) {
    CommandManager manager = ioc.singleton(ioc.services.command);
    CommandInteraction commandInteraction = CommandInteraction.from(user: member.user, payload: payload, guild: guild);

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

  _executeContextMenuInteraction (Guild guild, GuildMember member, dynamic payload) async {
    ContextMenuManager contextMenuManager = ioc.singleton(ioc.services.contextMenu);
    MineralContextMenu contextMenu = contextMenuManager.contextMenus.findOrFail((element) => element.name == payload['data']?['name']);

    if (payload['data']?['type'] == ApplicationCommandType.user.value) {
      GuildMember? targetMember = guild.members.cache.get(payload['data']?['target_id']);
      final interaction = ContextUserInteraction.from(target: targetMember, user: member.user, payload: payload, guild: guild);

      reflect(contextMenu).invoke(Symbol('handle'), [interaction]);
    }

    if (payload['data']?['type'] == ApplicationCommandType.message.value) {
      print('is Message');
      Http http = ioc.singleton(ioc.services.http);
      TextBasedChannel? channel = guild.channels.cache.get(payload['channel_id']);
      Message? message = channel?.messages.cache.get(payload['data']?['target_id']);

      if (message == null) {
        Response response = await http.get(url: '/channels/${payload['channel_id']}/messages/${payload['data']?['target_id']}');
        if (response.statusCode == 200) {
          message = Message.from(channel: channel!, payload: jsonDecode(response.body));
          channel.messages.cache.putIfAbsent(message.id, () => message!);
        }
      }

      final interaction = ContextMessageInteraction.from(message: message!, user: member.user, payload: payload, guild: guild);

      reflect(contextMenu).invoke(Symbol('handle'), [interaction]);
    }
  }

  _executeButtonInteraction (Guild guild, GuildMember member, dynamic payload) async {
    Http http = ioc.singleton(ioc.services.http);
    EventManager manager = ioc.singleton(ioc.services.event);

    TextBasedChannel? channel = guild.channels.cache.get(payload['channel_id']);
    Message? message = channel?.messages.cache.get(payload['message']['id']);

    if (message == null) {
      Response response = await http.get(url: '/channels/${channel?.id}/messages/${payload['message']['id']}');
      if (response.statusCode == 200) {
        message = Message.from(channel: channel!, payload: jsonDecode(response.body));
      }
    }

    ButtonInteraction buttonInteraction = ButtonInteraction.from(
      user: member.user,
      message: message!,
      payload: payload,
      guild: guild,
    );

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

  _executeModalInteraction (Guild guild, GuildMember member, dynamic payload) {
    EventManager manager = ioc.singleton(ioc.services.event);
    TextBasedChannel? channel = guild.channels.cache.get(payload['channel_id']);
    Message? message = channel?.messages.cache.get(payload['message']?['id']);

    ModalInteraction modalInteraction = ModalInteraction.from(
      user: member.user,
      message: message,
      payload: payload,
      guild: guild
    );

    for (dynamic row in payload['data']['components']) {
      for (dynamic component in row['components']) {
        modalInteraction.data.putIfAbsent(component['custom_id'], () => component['value']);
      }
    }

    manager.emit(
      event: Events.modalCreate,
      customId: modalInteraction.customId,
      params: [modalInteraction]
    );

    manager.emit(
      event: Events.modalCreate,
      params: [modalInteraction]
    );
  }

  void _executeSelectMenuInteraction (Guild guild, GuildMember member, dynamic payload) {
    EventManager manager = ioc.singleton(ioc.services.event);
    TextBasedChannel? channel = guild.channels.cache.get(payload['channel_id']);
    Message? message = channel?.messages.cache.get(payload['message']['id']);

    SelectMenuInteraction interaction = SelectMenuInteraction.from(
      user: member.user,
      message: message,
      payload: payload,
      guild: guild,
    );

    for (dynamic value in payload['data']['values']) {
      interaction.data.add(value);
    }

    manager.emit(
      event: Events.selectMenuCreate,
      customId: interaction.customId,
      params: [interaction]
    );

    manager.emit(
      event: Events.selectMenuCreate,
      params: [interaction]
    );
  }
}
