import 'package:collection/collection.dart';
import 'package:mineral/api.dart';
import 'package:mineral/contracts.dart';
import 'package:mineral/src/domains/components/selects/select_context.dart';
import 'package:mineral/src/domains/container/ioc_container.dart';
import 'package:mineral/src/domains/events/event.dart';
import 'package:mineral/src/infrastructure/internals/packets/listenable_packet.dart';
import 'package:mineral/src/infrastructure/internals/packets/packet_type.dart';
import 'package:mineral/src/infrastructure/internals/wss/shard_message.dart';

final class SelectInteractionCreatePacket implements ListenablePacket {
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

    final componentType = ComponentType.values.firstWhereOrNull(
        (e) => e.value == message.payload['data']['component_type']);

    if (type == InteractionType.messageComponent &&
        ComponentType.selectMenus.contains(componentType)) {
      final selectMenuType = ComponentType.values.firstWhereOrNull(
          (e) => e.value == message.payload['data']['component_type']);

      final serverId = Snowflake.nullable(message.payload['guild_id']);
      final SelectContext ctx = await switch (serverId) {
        String() => ServerSelectContext.fromMap(_dataStore, message.payload)
            as Future<SelectContext>,
        _ =>
          PrivateSelectContext.fromMap(_marshaller, _dataStore, message.payload)
              as Future<SelectContext>,
      };

      switch (selectMenuType) {
        case ComponentType.channelSelectMenu:
          _dispatchChannelSelectMenu(ctx, message.payload, dispatch);
        case ComponentType.roleSelectMenu:
          _dispatchRoleSelectMenu(ctx, message.payload, dispatch);
        case ComponentType.userSelectMenu:
          _dispatchUserSelectMenu(ctx, message.payload, dispatch);
        case ComponentType.mentionableSelectMenu:
          _dispatchMentionableSelectMenu(ctx, message.payload, dispatch);
        case ComponentType.textSelectMenu:
          _dispatchTextSelectMenu(ctx, message.payload, dispatch);
        default:
          _logger.warn('Select menu type $selectMenuType not found');
      }
    }
  }

  Future<void> _dispatchChannelSelectMenu(SelectContext ctx,
      Map<String, dynamic> payload, DispatchEvent dispatch) async {
    final serverChannels =
        await _dataStore.channel.fetch(payload['guild_id'], false);

    final resolvedData = payload['data']['resolved'];
    final channelIds = Map.from(resolvedData['channels']).keys;

    final channels =
        channelIds.map((id) => serverChannels[id]).whereType<ServerChannel>();

    _interactiveComponentManager.dispatch(ctx.customId, [ctx, channels]);

    return switch (ctx) {
      ServerSelectContext() => dispatch(
          event: Event.serverChannelSelect,
          params: [ctx, channels.whereType<ServerChannel>()],
          constraint: (String? customId) => customId == ctx.customId),
      PrivateSelectContext() => dispatch(
          event: Event.serverChannelSelect,
          params: [ctx, channels.whereType<Channel>()],
          constraint: (String? customId) => customId == ctx.customId),
      _ => _logger.warn('Select context $ctx not found'),
    };
  }

  Future<void> _dispatchRoleSelectMenu(SelectContext ctx,
      Map<String, dynamic> payload, DispatchEvent dispatch) async {
    final serverRoles = await _dataStore.role.fetch(payload['guild_id'], false);

    final resolvedData = payload['data']['resolved'];
    final roleIds = Map.from(resolvedData['roles']).keys;

    final resolvedRoles = roleIds.map((id) => serverRoles[id]);

    dispatch(
        event: Event.serverRoleSelect,
        params: [ctx, resolvedRoles],
        constraint: (String? customId) => customId == ctx.customId);

    _interactiveComponentManager.dispatch(ctx.customId, [ctx, resolvedRoles]);
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
          return _dataStore.member.get(payload['guild_id'], id, false);
        })),
      PrivateSelectContext() =>
        Future.wait(userIds.map((id) => _dataStore.user.get(id, false))),
      _ => Future.value([]),
    };

    _interactiveComponentManager
        .dispatch(ctx.customId, [ctx, resolvedResource]);

    dispatch(
        event: event,
        params: [ctx, resolvedResource],
        constraint: (String? customId) => customId == ctx.customId);
  }

  Future<void> _dispatchMentionableSelectMenu(
    SelectContext ctx,
    Map<String, dynamic> payload,
    DispatchEvent dispatch,
  ) async {
    final resolvedData = payload['data']['resolved'];
    final values = List<String>.from(payload['data']['values'] ?? []);
    final guildId = payload['guild_id'];

    final List<dynamic> mentionables = [];
    for (final id in values) {
      if (resolvedData['users'] != null && resolvedData['users'][id] != null) {
        final user = await _dataStore.user.get(id, false);
        if (user != null) {
          mentionables.add(user);
        }
      } else if (resolvedData['roles'] != null &&
          resolvedData['roles'][id] != null) {
        final role = await _dataStore.role.get(guildId, id, false);
        if (role != null) {
          mentionables.add(role);
        }
      }
    }

    _interactiveComponentManager.dispatch(ctx.customId, [ctx, mentionables]);

    dispatch(
      event: Event
          .serverRoleSelect, // Peut-être Event.serverMentionableSelect si défini
      params: [ctx, mentionables],
      constraint: (String? customId) => customId == ctx.customId,
    );
  }

  Future<void> _dispatchTextSelectMenu(SelectContext ctx,
      Map<String, dynamic> payload, DispatchEvent dispatch) async {
    final List<String> resolvedText = List.from(payload['data']['values']);

    _interactiveComponentManager.dispatch(ctx.customId, [ctx, resolvedText]);

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
