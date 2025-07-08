import 'dart:async';

import 'package:collection/collection.dart';
import 'package:mineral/api.dart';
import 'package:mineral/container.dart';
import 'package:mineral/contracts.dart';
import 'package:mineral/src/domains/events/event.dart';
import 'package:mineral/src/infrastructure/internals/packets/listenable_packet.dart';
import 'package:mineral/src/infrastructure/internals/packets/packet_type.dart';
import 'package:mineral/src/infrastructure/internals/wss/shard_message.dart';

final class ButtonInteractionCreatePacket implements ListenablePacket {
  @override
  PacketType get packetType => PacketType.interactionCreate;

  LoggerContract get _logger => ioc.resolve<LoggerContract>();

  InteractiveComponentManagerContract get _interactiveComponentManager =>
      ioc.resolve<InteractiveComponentManagerContract>();

  @override
  Future<void> listen(ShardMessage message, DispatchEvent dispatch) async {
    final type = InteractionType.values
        .firstWhereOrNull((e) => e.value == message.payload['type']);

    final componentType = ComponentType.values.firstWhereOrNull(
        (e) => e.value == message.payload['data']['component_type']);

    if (type == InteractionType.messageComponent &&
        componentType == ComponentType.button) {
      final serverId = Snowflake.nullable(message.payload['guild']?['id']);

      final type = ComponentType.values.firstWhereOrNull(
          (e) => e.value == message.payload['data']['component_type']);

      if (type == null) {
        _logger.warn(
            'Component type ${message.payload['data']['component_type']} not found');
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
    final metadata = payload['message']['interaction_metadata'];
    final targetButton =
        await _findButtonByCustomId(payload, payload['data']['custom_id']);
    final type = ButtonType.values
        .firstWhereOrNull((e) => e.value == targetButton?['type']);

    if (type == null) {
      _logger.warn('Button type ${metadata['type']} not found');
      return;
    }

    final ctx = ServerButtonContext(
      id: Snowflake.parse(payload['id']),
      applicationId: Snowflake.parse(payload['application_id']),
      version: payload['version'],
      token: payload['token'],
      customId: payload['data']['custom_id'],
      channelId: Snowflake.parse(payload['message']['channel_id']),
      messageId: Snowflake.parse(payload['message']['id']),
    );

    dispatch(
        event: Event.serverButtonClick,
        params: [ctx],
        constraint: (String? customId) => customId == ctx.customId);

    _interactiveComponentManager.dispatch(ctx.customId, [ctx]);
  }

  Future<void> _handlePrivateButton(
      Map<String, dynamic> payload, DispatchEvent dispatch) async {
    final metadata = payload['message']['interaction_metadata'];
    final targetButton =
        await _findButtonByCustomId(payload, payload['data']['custom_id']);
    final type = ButtonType.values
        .firstWhereOrNull((e) => e.value == targetButton?['custom_id']);

    if (type == null) {
      _logger.warn('Button type ${metadata['type']} not found');
      return;
    }

    final ctx = PrivateButtonContext(
      id: Snowflake.parse(payload['id']),
      applicationId: Snowflake.parse(payload['application_id']),
      version: payload['version'],
      token: payload['token'],
      customId: payload['data']['custom_id'],
      authorId: Snowflake.parse(payload['member']['user']['id']),
      channelId: Snowflake.parse(payload['channel_id']),
      messageId: Snowflake.parse(payload['message']['id']),
    );

    dispatch(
        event: Event.serverButtonClick,
        params: [ctx],
        constraint: (String? customId) => customId == ctx.customId);
  }

  Future<Map<String, dynamic>?> _findButtonByCustomId(
      Map<String, dynamic> payload, String customId) {
    final completer = Completer<Map<String, dynamic>?>();

    final components = payload['message']['components'] as List<dynamic>?;
    if (components != null) {
      for (final component in components) {
        final subComponents = component['components'] as List<dynamic>?;
        if (subComponents != null) {
          for (final subComponent in subComponents) {
            if (subComponent['custom_id'] == customId) {
              completer.complete(subComponent as Map<String, dynamic>);
            }
          }
        }
      }
    }

    return completer.future;
  }
}
