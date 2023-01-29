import 'dart:convert';

import 'package:http/http.dart';
import 'package:mineral/core.dart';
import 'package:mineral/core/api.dart';
import 'package:mineral/core/events.dart';
import 'package:mineral/framework.dart';
import 'package:mineral/src/api/builders/component_builder.dart';
import 'package:mineral/src/api/channels/dm_channel.dart';
import 'package:mineral/src/api/messages/partial_message.dart';
import 'package:mineral/src/internal/mixins/container.dart';
import 'package:mineral/src/internal/services/command_service.dart';
import 'package:mineral/src/internal/services/context_menu_service.dart';
import 'package:mineral/src/internal/services/event_service.dart';
import 'package:mineral/src/internal/websockets/events/interaction_create_event.dart';
import 'package:mineral/src/internal/websockets/websocket_packet.dart';
import 'package:mineral/src/internal/websockets/websocket_response.dart';
import 'package:mineral_cli/mineral_cli.dart';

class InteractionCreatePacket with Container implements WebsocketPacket {
  @override
  Future<void> handle(WebsocketResponse websocketResponse) async {
    EventService eventService = container.use<EventService>();
    MineralClient client = container.use<MineralClient>();

    dynamic payload = websocketResponse.payload;

    Guild? guild = client.guilds.cache.get(payload['guild_id']);
    GuildMember? member = guild?.members.cache.get(payload['member']['user']['id']);

    if (payload['type'] == InteractionType.applicationCommand.value && payload['data']['type'] == ApplicationCommandType.chatInput.value) {
      _executeCommandInteraction(payload);
    }

    if (payload['type'] == InteractionType.applicationCommand.value && payload['data']['type'] == ApplicationCommandType.user.value) {
      _executeContextMenuInteraction(guild!, member!, payload);
    }

    if (payload['type'] == InteractionType.applicationCommand.value && payload['data']['type'] == ApplicationCommandType.message.value) {
      _executeContextMenuInteraction(guild!, member!, payload);
    }

    if (payload['type'] == InteractionType.messageComponent.value && payload['data']['component_type'] == ComponentType.button.value) {
      _executeButtonInteraction(guild, payload);
    }

    if (payload['type'] == InteractionType.messageComponent.value && payload['data']['component_type'] == ComponentType.selectMenu.value) {
      _executeSelectMenuInteraction(guild!, member!, payload);
    }

    if (payload['type'] == InteractionType.modalSubmit.value) {
      _executeModalInteraction(payload);
    }

    if (member != null) {
      final Interaction interaction = Interaction.from(payload: payload);
      eventService.controller.add(InteractionCreateEvent(interaction));
    }
  }

  _executeCommandInteraction (dynamic payload) {
    CommandInteraction interaction = CommandInteraction.fromPayload(payload);
    container.use<CommandService>().controller.add(CommandCreateEvent(interaction, payload));
  }

  _executeContextMenuInteraction (Guild guild, GuildMember member, dynamic payload) async {
    if (payload['data']?['type'] == ApplicationCommandType.user.value) {
      final interaction = ContextUserInteraction.from(payload: payload );
      container.use<ContextMenuService>().controller.add(interaction);
    }

    if (payload['data']?['type'] == ApplicationCommandType.message.value) {
      TextBasedChannel? channel = guild.channels.cache.get(payload['channel_id']);
      Message? message = channel?.messages.cache.get(payload['data']?['target_id']);

      if (message == null) {
        Response response = await container.use<DiscordApiHttpService>()
          .get(url: '/channels/${payload['channel_id']}/messages/${payload['data']?['target_id']}')
          .build();

        if (response.statusCode == 200) {
          message = Message.from(channel: channel!, payload: jsonDecode(response.body));
          channel.messages.cache.putIfAbsent(message.id, () => message!);
        }
      }

      final interaction = ContextMessageInteraction.from(message: message!, payload: payload);
      container.use<ContextMenuService>().controller.add(interaction);
    }
  }

  _executeButtonInteraction (Guild? guild, dynamic payload) async {
    EventService eventService = container.use<EventService>();

    PartialChannel? channel = payload['guild_id'] != null
      ? await guild?.channels.get(payload['channel_id'])
      : await container.use<MineralClient>().dmChannels.get(payload['channel_id']);

    if(channel is DmChannel) {
      DmMessage message = await channel.messages.get(payload['message']['id']);
      channel.messages.cache.putIfAbsent(message.id, () => message);
    } else if(channel is PartialTextChannel) {
      Message message = await channel.messages.get(payload['message']['id']);
      channel.messages.cache.putIfAbsent(message.id, () => message);
    }

    ButtonInteraction buttonInteraction = ButtonInteraction.fromPayload(payload);
    eventService.controller.add(ButtonCreateEvent(buttonInteraction));
  }

  _executeModalInteraction (dynamic payload) {
    EventService eventService = container.use<EventService>();
    ModalInteraction modalInteraction = ModalInteraction.from(payload: payload);

    for (dynamic row in payload['data']['components']) {
      for (dynamic component in row['components']) {
        modalInteraction.data.putIfAbsent(component['custom_id'], () => component['value']);
      }
    }

    eventService.controller.add(ModalCreateEvent(modalInteraction));
  }

  void _executeSelectMenuInteraction (Guild guild, GuildMember member, dynamic payload) {
    EventService eventService = container.use<EventService>();
    TextBasedChannel? channel = guild.channels.cache.get(payload['channel_id']);
    Message? message = channel?.messages.cache.get(payload['message']['id']);

    SelectMenuInteraction interaction = SelectMenuInteraction.from(
      message: message,
      payload: payload,
    );

    for (dynamic value in payload['data']['values']) {
      interaction.data.add(value);
    }

    eventService.controller.add(SelectMenuCreateEvent(interaction));
  }
}
