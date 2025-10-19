import 'package:collection/collection.dart';
import 'package:mineral/contracts.dart';
import 'package:mineral/src/api/common/types/interaction_type.dart';
import 'package:mineral/src/domains/components/modal/contexts/private_modal_context.dart';
import 'package:mineral/src/domains/components/modal/contexts/server_modal_context.dart';
import 'package:mineral/src/domains/container/ioc_container.dart';
import 'package:mineral/src/domains/events/event.dart';
import 'package:mineral/src/infrastructure/internals/packets/listenable_packet.dart';
import 'package:mineral/src/infrastructure/internals/packets/packet_type.dart';
import 'package:mineral/src/infrastructure/internals/wss/shard_message.dart';

final class ModalInteractionCreatePacket implements ListenablePacket {
  @override
  PacketType get packetType => PacketType.interactionCreate;

  LoggerContract get _logger => ioc.resolve<LoggerContract>();

  MarshallerContract get _marshaller => ioc.resolve<MarshallerContract>();

  DataStoreContract get _dataStore => ioc.resolve<DataStoreContract>();

  InteractiveComponentManagerContract get _interactiveComponentManager =>
      ioc.resolve<InteractiveComponentManagerContract>();

  @override
  Future<void> listen(ShardMessage message, DispatchEvent dispatch) async {
    final type = InteractionType.values
        .firstWhereOrNull((e) => e.value == message.payload['type']);

    if (type == InteractionType.modal) {
      final interactionContext = InteractionContextType.values.firstWhereOrNull(
        (element) => element.value == message.payload['context'],
      );

      final Map<String, dynamic> parameters = {};
      final components = List.from(message.payload['data']['components']);
      for (final row in components) {
        if (row['component'] == null) {
          continue;
        }
        final component = row['component'];
        final customId = component['custom_id'];

        if (component.containsKey('values')) {
          // Detect type by customId naming convention (user_select, role_select, channel_select)
          final values = List<String>.from(component['values'] ?? []);
          if (customId.contains('user_select')) {
            // Resolve User instances
            parameters[customId] = await Future.wait(
                values.map((id) => _dataStore.user.get(id, false)));
          } else if (customId.contains('role_select')) {
            // Resolve Role instances
            final guildId = message.payload['guild_id'];
            parameters[customId] = await Future.wait(
                values.map((id) => _dataStore.role.get(guildId, id, false)));
          } else if (customId.contains('channel_select')) {
            // Resolve Channel instances
            parameters[customId] = await Future.wait(
                values.map((id) => _dataStore.channel.get(id, false)));
          } else {
            // Default: just pass IDs
            parameters[customId] = values;
          }
        } else {
          parameters[customId] = component['value']?.toString() ?? '';
        }
      }

      final event = switch (interactionContext) {
        InteractionContextType.server => Event.serverModalSubmit,
        InteractionContextType.privateChannel => Event.privateModalSubmit,
        _ => null
      };

      final ctx = await switch (interactionContext) {
        InteractionContextType.server =>
          ServerModalContext.fromMap(_dataStore, message.payload),
        InteractionContextType.privateChannel =>
          PrivateModalContext.fromMap(_marshaller, message.payload),
        _ => null
      };

      if ([event, ctx].contains(null)) {
        _logger.warn(
            'Interaction context ${message.payload['context']} not found');
        return;
      }

      dispatch(
          event: event!,
          params: [ctx, parameters],
          constraint: (String? customId) => switch (customId) {
                final String value => value == ctx!.customId,
                _ => true
              });

      _interactiveComponentManager.dispatch(ctx!.customId, [ctx, parameters]);
    }
  }
}
