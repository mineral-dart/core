import 'package:collection/collection.dart';
import 'package:mineral/contracts.dart';
import 'package:mineral/src/api/common/types/interaction_type.dart';
import 'package:mineral/src/domains/components/dialog/contexts/private_dialog_context.dart';
import 'package:mineral/src/domains/components/dialog/contexts/server_dialog_context.dart';
import 'package:mineral/src/domains/container/ioc_container.dart';
import 'package:mineral/src/domains/events/event.dart';
import 'package:mineral/src/infrastructure/internals/packets/listenable_packet.dart';
import 'package:mineral/src/infrastructure/internals/packets/packet_type.dart';
import 'package:mineral/src/infrastructure/internals/wss/shard_message.dart';

final class DialogInteractionCreatePacket implements ListenablePacket {
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
          (element) => element.value == message.payload['context']);

      final Map<String, String> parameters =
          List.from(message.payload['data']['components']).map((row) {
        final component = row['components'][0];
        return {component['custom_id']: component['value']};
      }).fold({}, (prev, curr) => {...prev, ...curr});

      final event = switch (interactionContext) {
        InteractionContextType.server => Event.serverDialogSubmit,
        InteractionContextType.privateChannel => Event.privateDialogSubmit,
        _ => null
      };

      final ctx = await switch (interactionContext) {
        InteractionContextType.server =>
          ServerDialogContext.fromMap(_dataStore, message.payload),
        InteractionContextType.privateChannel =>
          PrivateDialogContext.fromMap(_marshaller, message.payload),
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
