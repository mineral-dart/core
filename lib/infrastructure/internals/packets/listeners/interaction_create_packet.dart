import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:mineral/api/common/components/buttons/button_type.dart';
import 'package:mineral/api/common/components/component_type.dart';
import 'package:mineral/api/common/snowflake.dart';
import 'package:mineral/api/common/types/interaction_type.dart';
import 'package:mineral/domains/commands/command_interaction_manager.dart';
import 'package:mineral/domains/components/buttons/contexts/private_button_context.dart';
import 'package:mineral/domains/components/buttons/contexts/server_button_context.dart';
import 'package:mineral/domains/components/dialog/contexts/private_dialog_context.dart';
import 'package:mineral/domains/components/dialog/contexts/server_dialog_context.dart';
import 'package:mineral/domains/components/selects/contexts/server_select_context.dart';
import 'package:mineral/domains/events/event.dart';
import 'package:mineral/infrastructure/internals/container/ioc_container.dart';
import 'package:mineral/infrastructure/internals/interactions/types/interaction_context_type.dart';
import 'package:mineral/infrastructure/internals/marshaller/marshaller.dart';
import 'package:mineral/infrastructure/internals/packets/listenable_packet.dart';
import 'package:mineral/infrastructure/internals/packets/packet_type.dart';
import 'package:mineral/infrastructure/internals/wss/shard_message.dart';
import 'package:mineral/infrastructure/services/logger/logger.dart';

final class InteractionCreatePacket implements ListenablePacket {
  @override
  PacketType get packetType => PacketType.interactionCreate;

  final LoggerContract logger;
  final MarshallerContract marshaller;

  InteractionCreatePacket(this.logger, this.marshaller);

  @override
  Future<void> listen(ShardMessage message, DispatchEvent dispatch) async {
    final interactionManager = ioc.resolve<CommandInteractionManagerContract>();
    final type = InteractionType.values.firstWhereOrNull((e) => e.value == message.payload['type']);

    final componentType = ComponentType.values
        .firstWhereOrNull((e) => e.value == message.payload['data']['component_type']);

    return switch (type) {
      InteractionType.applicationCommand => interactionManager.dispatcher.dispatch(message.payload),
      InteractionType.messageComponent when componentType == ComponentType.button =>
        dispatchMessageComponent(message.payload, dispatch),
      InteractionType.messageComponent when ComponentType.selectMenus.contains(componentType) =>
        dispatchSelectComponent(message.payload, dispatch),
      InteractionType.modal => dispatchModalComponent(message.payload, dispatch),
      _ => logger.warn('Interaction type ${message.payload['type']} not found')
    };
  }

  Future<void> dispatchMessageComponent(
      Map<String, dynamic> payload, DispatchEvent dispatch) async {
    final String? serverId = payload['guild']?['id'];

    final metadata = payload['message']['interaction_metadata'];
    final type = ComponentType.values.firstWhereOrNull((e) => e.value == metadata['type']);

    if (type == null) {
      logger.warn('Component type ${metadata['type']} not found');
      return;
    }

    return switch (serverId) {
      String() => _handleServerButton(payload, dispatch),
      _ => _handlePrivateButton(payload, dispatch),
    };
  }

  Future<void> _handleServerButton(Map<String, dynamic> payload, DispatchEvent dispatch) async {
    final message = await marshaller.dataStore.message.getServerMessage(
        messageId: Snowflake(payload['message']['id']),
        channelId: Snowflake(payload['channel_id']));

    final metadata = payload['message']['interaction_metadata'];
    final type = ButtonType.values.firstWhereOrNull((e) => e.value == metadata['type']);

    if (type == null) {
      logger.warn('Button type ${metadata['type']} not found');
      return;
    }

    final ctx = ServerButtonContext(
      id: Snowflake(payload['id']),
      applicationId: Snowflake(payload['application_id']),
      version: payload['version'],
      token: payload['token'],
      customId: payload['data']['custom_id'],
      message: message,
      member: message.author,
    );

    dispatch(event: Event.serverButtonClick, params: [ctx]);
  }

  Future<void> _handlePrivateButton(Map<String, dynamic> payload, DispatchEvent dispatch) async {
    final message = await marshaller.dataStore.message.getPrivateMessage(
        messageId: Snowflake(payload['message']['id']),
        channelId: Snowflake(payload['channel_id']));

    final metadata = payload['message']['interaction_metadata'];
    final type = ButtonType.values.firstWhereOrNull((e) => e.value == metadata['type']);

    if (type == null) {
      logger.warn('Button type ${metadata['type']} not found');
      return;
    }

    final ctx = PrivateButtonContext(
      id: Snowflake(payload['id']),
      applicationId: Snowflake(payload['application_id']),
      version: payload['version'],
      token: payload['token'],
      customId: payload['data']['custom_id'],
      message: message,
      user: message.author,
    );

    dispatch(event: Event.serverButtonClick, params: [ctx]);
  }

  Future<void> dispatchModalComponent(Map<String, dynamic> payload, DispatchEvent dispatch) async {
    final interactionContext = InteractionContextType.values
        .firstWhereOrNull((element) => element.value == payload['context']);

    final Map<Symbol, dynamic> parameters = List.from(payload['data']['components']).map((row) {
      final component = row['components'][0];
      return {Symbol(component['custom_id']): component['value']};
    }).fold({}, (prev, curr) => {...prev, ...curr});

    final event = switch (interactionContext) {
      InteractionContextType.server => Event.serverDialogSubmit,
      InteractionContextType.privateChannel => Event.privateDialogSubmit,
      _ => null
    };

    final ctx = switch (interactionContext) {
      InteractionContextType.server => ServerDialogContext(
          customId: payload['data']['custom_id'],
          id: Snowflake(payload['id']),
          applicationId: Snowflake(payload['application_id']),
          token: payload['token'],
          version: payload['version'],
          member: await marshaller.dataStore.member.getMember(
            guildId: Snowflake(payload['guild_id']),
            memberId: Snowflake(payload['member']['user']['id']),
          ),
        ),
      InteractionContextType.privateChannel => PrivateDialogContext(
          customId: payload['data']['custom_id'],
          id: Snowflake(payload['id']),
          applicationId: Snowflake(payload['application_id']),
          token: payload['token'],
          version: payload['version'],
          user: await marshaller.serializers.user.serializeRemote(payload['user']),
        ),
      _ => null
    };

    if ([event, ctx].contains(null)) {
      logger.warn('Interaction context ${payload['context']} not found');
      return;
    }

    dispatch(
        event: event!,
        params: [ctx, parameters],
        constraint: (String? customId) => customId == ctx!.customId);
  }

  Future<void> dispatchSelectComponent(Map<String, dynamic> payload, DispatchEvent dispatch) async {
    final selectMenuType =
        ComponentType.values.firstWhereOrNull((e) => e.value == payload['data']['component_type']);

    print(selectMenuType);

    switch (selectMenuType) {
      case ComponentType.channelSelectMenu:
        _dispatchSelectMenu(payload, dispatch);
      default:
        logger.warn('Select menu type $selectMenuType not found');
    }
  }

  Future<void> _dispatchSelectMenu(Map<String, dynamic> payload, DispatchEvent dispatch) async {
    final resolvedData = payload['data']['resolved'];
    final channelIds = Map.from(resolvedData['channels']).keys;

    final ctx = ServerSelectContext(
      id: Snowflake(payload['id']),
      applicationId: Snowflake(payload['application_id']),
      token: payload['token'],
      version: payload['version'],
      customId: payload['data']['custom_id'],
      message: await marshaller.dataStore.message.getServerMessage(
        messageId: Snowflake(payload['message']['id']),
        channelId: Snowflake(payload['channel_id']),
      ),
      member: await marshaller.dataStore.member.getMember(
        guildId: Snowflake(payload['guild_id']),
        memberId: Snowflake(payload['member']['user']['id']),
      ),
    );

    final data = await Future.wait(channelIds.map((id) async {
      final cacheKey = marshaller.cacheKey.channel(Snowflake(id));
      final rawChannel = await marshaller.cache.getOrFail(cacheKey);

      return marshaller.serializers.channels.serializeCache(rawChannel);
    }));

    dispatch(
        event: Event.serverChannelSelect,
        params: [ctx, data],
        constraint: (String? customId) => customId == ctx.customId);
  }
}
