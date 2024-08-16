import 'package:collection/collection.dart';
import 'package:mineral/api/common/channel.dart';
import 'package:mineral/api/common/components/component_type.dart';
import 'package:mineral/api/common/snowflake.dart';
import 'package:mineral/api/common/types/interaction_type.dart';
import 'package:mineral/api/server/channels/server_channel.dart';
import 'package:mineral/api/server/role.dart';
import 'package:mineral/domains/components/selects/button_context.dart';
import 'package:mineral/domains/components/selects/contexts/private_select_context.dart';
import 'package:mineral/domains/components/selects/contexts/server_select_context.dart';
import 'package:mineral/domains/events/event.dart';
import 'package:mineral/infrastructure/internals/marshaller/marshaller.dart';
import 'package:mineral/infrastructure/internals/packets/listenable_packet.dart';
import 'package:mineral/infrastructure/internals/packets/packet_type.dart';
import 'package:mineral/infrastructure/internals/wss/shard_message.dart';
import 'package:mineral/infrastructure/services/logger/logger.dart';

final class SelectInteractionCreatePacket implements ListenablePacket {
  @override
  PacketType get packetType => PacketType.interactionCreate;

  final LoggerContract logger;
  final MarshallerContract marshaller;

  SelectInteractionCreatePacket(this.logger, this.marshaller);

  @override
  Future<void> listen(ShardMessage message, DispatchEvent dispatch) async {
    final type = InteractionType.values.firstWhereOrNull((e) => e.value == message.payload['type']);

    final componentType = ComponentType.values
        .firstWhereOrNull((e) => e.value == message.payload['data']['component_type']);

    if (type == InteractionType.messageComponent &&
        ComponentType.selectMenus.contains(componentType)) {
      final selectMenuType = ComponentType.values
          .firstWhereOrNull((e) => e.value == message.payload['data']['component_type']);

      final ctx = await switch (message.payload['guild_id']) {
        String() => ServerSelectContext.fromMap(marshaller, message.payload),
        _ => PrivateSelectContext.fromMap(marshaller, message.payload),
      };

      switch (selectMenuType) {
        case ComponentType.channelSelectMenu:
          _dispatchChannelSelectMenu(ctx, message.payload, dispatch);
        case ComponentType.roleSelectMenu:
          _dispatchRoleSelectMenu(ctx, message.payload, dispatch);
        case ComponentType.userSelectMenu:
          _dispatchUserSelectMenu(ctx, message.payload, dispatch);
        case ComponentType.textSelectMenu:
          _dispatchTextSelectMenu(ctx, message.payload, dispatch);
        default:
          logger.warn('Select menu type $selectMenuType not found');
      }
    }
  }

  Future<void> _dispatchChannelSelectMenu(
      SelectContext ctx, Map<String, dynamic> payload, DispatchEvent dispatch) async {
    final resolvedData = payload['data']['resolved'];
    final channelIds = Map.from(resolvedData['channels']).keys;

    Future<List<T>> resolveChannels<T extends Channel>() {
      return Future.wait(channelIds.map((id) async {
        final cacheKey = marshaller.cacheKey.channel(Snowflake(id));
        final rawChannel = await marshaller.cache.getOrFail(cacheKey);

        return marshaller.serializers.channelsserialize(rawChannel) as Future<T>;
      }));
    }

    return switch (ctx) {
      ServerSelectContext() => dispatch(
          event: Event.serverChannelSelect,
          params: [ctx, await resolveChannels<ServerChannel>()],
          constraint: (String? customId) => customId == ctx.customId),
      PrivateSelectContext() => dispatch(
          event: Event.serverChannelSelect,
          params: [ctx, await resolveChannels<Channel>()],
          constraint: (String? customId) => customId == ctx.customId),
      _ => logger.warn('Select context $ctx not found'),
    };
  }

  Future<void> _dispatchRoleSelectMenu(
      SelectContext ctx, Map<String, dynamic> payload, DispatchEvent dispatch) async {
    final resolvedData = payload['data']['resolved'];
    final roleIds = Map.from(resolvedData['roles']).keys;

    final List<Role> resolvedRoles = await Future.wait(roleIds.map((id) async {
      final cacheKey =
          marshaller.cacheKey.serverRole(serverId: payload['guild_id'], roleId: Snowflake(id));
      final rawRole = await marshaller.cache.getOrFail(cacheKey);

      return marshaller.serializers.roleserialize(rawRole);
    }));

    dispatch(
        event: Event.serverRoleSelect,
        params: [ctx, resolvedRoles],
        constraint: (String? customId) => customId == ctx.customId);
  }

  Future<void> _dispatchUserSelectMenu(
      SelectContext ctx, Map<String, dynamic> payload, DispatchEvent dispatch) async {
    final resolvedData = payload['data']['resolved'];
    final userIds = Map.from(resolvedData['users']).keys;

    final event = switch (ctx) {
      ServerSelectContext() => Event.serverMemberSelect,
      PrivateSelectContext() => Event.privateUserSelect,
      _ => null,
    };

    if (event == null) {
      logger.warn('Select context $ctx not found');
      return;
    }

    final resolvedResource = await switch (ctx) {
      ServerSelectContext() => Future.wait(userIds.map((id) {
          return marshaller.dataStore.member.getMember(
            guildId: Snowflake(payload['guild_id']),
            memberId: Snowflake(id),
          );
        })),
      PrivateSelectContext() =>
        Future.wait(userIds.map((id) => marshaller.dataStore.user.getUser(id))),
      _ => Future.value([]),
    };

    dispatch(
        event: event,
        params: [ctx, resolvedResource],
        constraint: (String? customId) => customId == ctx.customId);
  }

  Future<void> _dispatchTextSelectMenu(
      SelectContext ctx, Map<String, dynamic> payload, DispatchEvent dispatch) async {
    final List<String> resolvedText = List.from(payload['data']['values']);

    return switch (ctx) {
      ServerSelectContext() => dispatch(
          event: Event.serverTextSelect,
          params: [ctx, resolvedText],
          constraint: (String? customId) => customId == ctx.customId),
      PrivateSelectContext() => dispatch(
          event: Event.privateTextSelect,
          params: [ctx, resolvedText],
          constraint: (String? customId) => customId == ctx.customId),
      _ => logger.warn('Select context $ctx not found'),
    };
  }
}
