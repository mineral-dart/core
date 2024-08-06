import 'package:collection/collection.dart';
import 'package:mineral/api/common/components/buttons/button_type.dart';
import 'package:mineral/api/common/components/component_type.dart';
import 'package:mineral/api/common/snowflake.dart';
import 'package:mineral/api/common/types/interaction_type.dart';
import 'package:mineral/domains/commands/command_interaction_manager.dart';
import 'package:mineral/domains/components/buttons/contexts/server_button_context.dart';
import 'package:mineral/domains/events/event.dart';
import 'package:mineral/infrastructure/internals/container/ioc_container.dart';
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

    return switch (type) {
      InteractionType.applicationCommand => interactionManager.dispatcher.dispatch(message.payload),
      InteractionType.messageComponent => dispatchMessageComponent(message.payload, dispatch),
      _ => logger.warn('Interaction type ${message.payload['type']} not found')
    };
  }

  Future<void> dispatchMessageComponent(Map<String, dynamic> payload, DispatchEvent dispatch) async {
    final String? serverId = payload['guild']?['id'];

    final metadata = payload['message']['interaction_metadata'];
    final type = ComponentType.values.firstWhereOrNull((e) => e.value == metadata['type']);

    if (type == null) {
      logger.warn('Component type ${metadata['type']} not found');
      return;
    }

    return switch (serverId) {
      String() => _handleServerButton(payload, dispatch),
      _ => _handlePrivateButton(payload),
    };
  }

  Future<void> _handleServerButton(Map<String, dynamic> payload, DispatchEvent dispatch) async {
    final message = await marshaller.dataStore.message.getServerMessage(
        messageId: Snowflake(payload['message']['id']), channelId: Snowflake(payload['channel_id']));

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
      message: message,
      member: message.author,
    );

    dispatch(event: Event.serverButtonClick, params: [ctx]);
  }

  Future<void> _handlePrivateButton(Map<String, dynamic> data) async {}
}
