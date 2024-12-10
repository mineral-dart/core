import 'package:collection/collection.dart';
import 'package:mineral/container.dart';
import 'package:mineral/contracts.dart';
import 'package:mineral/src/api/common/components/buttons/button_type.dart';
import 'package:mineral/src/api/common/components/component_type.dart';
import 'package:mineral/src/api/common/snowflake.dart';
import 'package:mineral/src/api/common/types/interaction_type.dart';
import 'package:mineral/src/domains/components/buttons/contexts/private_button_context.dart';
import 'package:mineral/src/domains/components/buttons/contexts/server_button_context.dart';
import 'package:mineral/src/domains/events/event.dart';
import 'package:mineral/src/infrastructure/internals/packets/listenable_packet.dart';
import 'package:mineral/src/infrastructure/internals/packets/packet_type.dart';
import 'package:mineral/src/infrastructure/internals/wss/shard_message.dart';

final class ButtonInteractionCreatePacket implements ListenablePacket {
  @override
  PacketType get packetType => PacketType.interactionCreate;

  LoggerContract get _logger => ioc.resolve<LoggerContract>();
  DataStoreContract get _dataStore => ioc.resolve<DataStoreContract>();

  @override
  Future<void> listen(ShardMessage message, DispatchEvent dispatch) async {
    final type = InteractionType.values
        .firstWhereOrNull((e) => e.value == message.payload['type']);

    final componentType = ComponentType.values.firstWhereOrNull(
        (e) => e.value == message.payload['data']['component_type']);

    if (type == InteractionType.messageComponent &&
        componentType == ComponentType.button) {
      final String? serverId = message.payload['guild']?['id'];

      final metadata = message.payload['message']['interaction_metadata'];
      final type = ComponentType.values
          .firstWhereOrNull((e) => e.value == metadata['type']);

      if (type == null) {
        _logger.warn('Component type ${metadata['type']} not found');
        return;
      }

      return switch (serverId) {
        String() => _handleServerButton(message.payload, dispatch),
        _ => _handlePrivateButton(message.payload, dispatch),
      };
    }
  }

  Future<void> _handleServerButton(
      Map<String, dynamic> payload, DispatchEvent dispatch) async {
    final message = await _dataStore.message.getServerMessage(
        messageId: Snowflake(payload['message']['id']),
        channelId: Snowflake(payload['channel_id']));

    final metadata = payload['message']['interaction_metadata'];
    final type =
        ButtonType.values.firstWhereOrNull((e) => e.value == metadata['type']);

    if (type == null) {
      _logger.warn('Button type ${metadata['type']} not found');
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

    dispatch(
        event: Event.serverButtonClick,
        params: [ctx],
        constraint: (String? customId) => customId == ctx.customId);
  }

  Future<void> _handlePrivateButton(
      Map<String, dynamic> payload, DispatchEvent dispatch) async {
    final message = await _dataStore.message.getPrivateMessage(
        messageId: Snowflake(payload['message']['id']),
        channelId: Snowflake(payload['channel_id']));

    final metadata = payload['message']['interaction_metadata'];
    final type =
        ButtonType.values.firstWhereOrNull((e) => e.value == metadata['type']);

    if (type == null) {
      _logger.warn('Button type ${metadata['type']} not found');
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

    dispatch(
        event: Event.serverButtonClick,
        params: [ctx],
        constraint: (String? customId) => customId == ctx.customId);
  }
}
