import 'package:collection/collection.dart';
import 'package:mineral/container.dart';
import 'package:mineral/src/api/common/channel.dart';
import 'package:mineral/src/api/common/components/component_type.dart';
import 'package:mineral/src/api/common/snowflake.dart';
import 'package:mineral/src/api/common/types/interaction_type.dart';
import 'package:mineral/src/api/server/channels/server_channel.dart';
import 'package:mineral/src/api/server/role.dart';
import 'package:mineral/src/domains/components/selects/button_context.dart';
import 'package:mineral/src/domains/components/selects/contexts/private_select_context.dart';
import 'package:mineral/src/domains/components/selects/contexts/server_select_context.dart';
import 'package:mineral/src/domains/events/event.dart';
import 'package:mineral/src/infrastructure/internals/datastore/data_store.dart';
import 'package:mineral/src/infrastructure/internals/marshaller/marshaller.dart';
import 'package:mineral/src/infrastructure/internals/packets/listenable_packet.dart';
import 'package:mineral/src/infrastructure/internals/packets/packet_type.dart';
import 'package:mineral/src/infrastructure/internals/wss/shard_message.dart';
import 'package:mineral/src/infrastructure/services/logger/logger.dart';

final class SelectInteractionCreatePacket implements ListenablePacket {
  @override
  PacketType get packetType => PacketType.interactionCreate;

  LoggerContract get _logger => ioc.resolve<LoggerContract>();

  MarshallerContract get _marshaller => ioc.resolve<MarshallerContract>();

  DataStoreContract get _dataStore => ioc.resolve<DataStoreContract>();

  @override
  Future<void> listen(ShardMessage message, DispatchEvent dispatch) async {
    final type = InteractionType.values
        .firstWhereOrNull((e) => e.value == message.payload['type']);

    final componentType = ComponentType.values.firstWhereOrNull(
        (e) => e.value == message.payload['data']['component_type']);

    if (type == InteractionType.messageComponent &&
        ComponentType.selectMenus.contains(componentType)) {
      final selectMenuType = ComponentType.values.firstWhereOrNull(
          (e) => e.value == message.payload['data']['component_type']);

      final ctx = await switch (message.payload['guild_id']) {
        String() => ServerSelectContext.fromMap(_dataStore, message.payload),
        _ => PrivateSelectContext.fromMap(
            _marshaller, _dataStore, message.payload),
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
          _logger.warn('Select menu type $selectMenuType not found');
      }
    }
  }

  Future<void> _dispatchChannelSelectMenu(SelectContext ctx,
      Map<String, dynamic> payload, DispatchEvent dispatch) async {
    final resolvedData = payload['data']['resolved'];
    final channelIds = Map.from(resolvedData['channels']).keys;

    Future<List<T>> resolveChannels<T extends Channel>() {
      return Future.wait(channelIds.map((id) async {
        final cacheKey = _marshaller.cacheKey.channel(Snowflake(id));
        final rawChannel = await _marshaller.cache.getOrFail(cacheKey);

        return _marshaller.serializers.channels.serialize(rawChannel)
            as Future<T>;
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
      _ => _logger.warn('Select context $ctx not found'),
    };
  }

  Future<void> _dispatchRoleSelectMenu(SelectContext ctx,
      Map<String, dynamic> payload, DispatchEvent dispatch) async {
    final resolvedData = payload['data']['resolved'];
    final roleIds = Map.from(resolvedData['roles']).keys;

    final List<Role> resolvedRoles = await Future.wait(roleIds.map((id) async {
      final cacheKey =
          _marshaller.cacheKey.serverRole(payload['guild_id'], Snowflake(id));
      final rawRole = await _marshaller.cache.getOrFail(cacheKey);

      return _marshaller.serializers.role.serialize(rawRole);
    }));

    dispatch(
        event: Event.serverRoleSelect,
        params: [ctx, resolvedRoles],
        constraint: (String? customId) => customId == ctx.customId);
  }

  Future<void> _dispatchUserSelectMenu(SelectContext ctx,
      Map<String, dynamic> payload, DispatchEvent dispatch) async {
    final resolvedData = payload['data']['resolved'];
    final userIds = Map.from(resolvedData['users']).keys;

    final event = switch (ctx) {
      ServerSelectContext() => Event.serverMemberSelect,
      PrivateSelectContext() => Event.privateUserSelect,
      _ => null,
    };

    if (event == null) {
      _logger.warn('Select context $ctx not found');
      return;
    }

    final resolvedResource = await switch (ctx) {
      ServerSelectContext() => Future.wait(userIds.map((id) {
          return _dataStore.member.getMember(
            serverId: Snowflake(payload['guild_id']),
            memberId: Snowflake(id),
          );
        })),
      PrivateSelectContext() =>
        Future.wait(userIds.map((id) => _dataStore.user.getUser(id))),
      _ => Future.value([]),
    };

    dispatch(
        event: event,
        params: [ctx, resolvedResource],
        constraint: (String? customId) => customId == ctx.customId);
  }

  Future<void> _dispatchTextSelectMenu(SelectContext ctx,
      Map<String, dynamic> payload, DispatchEvent dispatch) async {
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
      _ => _logger.warn('Select context $ctx not found'),
    };
  }
}
