import 'package:collection/collection.dart';
import 'package:mineral/api/common/snowflake.dart';
import 'package:mineral/api/common/types/interaction_type.dart';
import 'package:mineral/domains/components/dialog/contexts/private_dialog_context.dart';
import 'package:mineral/domains/components/dialog/contexts/server_dialog_context.dart';
import 'package:mineral/domains/events/event.dart';
import 'package:mineral/infrastructure/internals/interactions/types/interaction_context_type.dart';
import 'package:mineral/infrastructure/internals/marshaller/marshaller.dart';
import 'package:mineral/infrastructure/internals/packets/listenable_packet.dart';
import 'package:mineral/infrastructure/internals/packets/packet_type.dart';
import 'package:mineral/infrastructure/internals/wss/shard_message.dart';
import 'package:mineral/infrastructure/services/logger/logger.dart';

final class DialogInteractionCreatePacket implements ListenablePacket {
  @override
  PacketType get packetType => PacketType.interactionCreate;

  final LoggerContract logger;
  final MarshallerContract marshaller;

  DialogInteractionCreatePacket(this.logger, this.marshaller);

  @override
  Future<void> listen(ShardMessage message, DispatchEvent dispatch) async {
    final type = InteractionType.values.firstWhereOrNull((e) => e.value == message.payload['type']);

    if (type == InteractionType.modal) {
      final interactionContext = InteractionContextType.values
          .firstWhereOrNull((element) => element.value == message.payload['context']);

      final Map<Symbol, dynamic> parameters =
          List.from(message.payload['data']['components']).map((row) {
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
            customId: message.payload['data']['custom_id'],
            id: Snowflake(message.payload['id']),
            applicationId: Snowflake(message.payload['application_id']),
            token: message.payload['token'],
            version: message.payload['version'],
            member: await marshaller.dataStore.member.getMember(
              guildId: Snowflake(message.payload['guild_id']),
              memberId: Snowflake(message.payload['member']['user']['id']),
            ),
          ),
        InteractionContextType.privateChannel => PrivateDialogContext(
            customId: message.payload['data']['custom_id'],
            id: Snowflake(message.payload['id']),
            applicationId: Snowflake(message.payload['application_id']),
            token: message.payload['token'],
            version: message.payload['version'],
            user: await marshaller.serializers.user.serializeRemote(message.payload['user']),
          ),
        _ => null
      };

      if ([event, ctx].contains(null)) {
        logger.warn('Interaction context ${message.payload['context']} not found');
        return;
      }

      dispatch(
          event: event!,
          params: [ctx, parameters],
          constraint: (String? customId) => customId == ctx!.customId);
    }
  }
}
