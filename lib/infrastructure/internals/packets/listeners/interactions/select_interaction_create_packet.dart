import 'dart:convert';

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

      final ctx = switch (message.payload['guild_id']) {
        String() => ServerSelectContext(
            id: Snowflake(message.payload['id']),
            applicationId: Snowflake(message.payload['application_id']),
            token: message.payload['token'],
            version: message.payload['version'],
            customId: message.payload['data']['custom_id'],
            message: await marshaller.dataStore.message.getServerMessage(
              messageId: Snowflake(message.payload['message']['id']),
              channelId: Snowflake(message.payload['channel_id']),
            ),
            member: await marshaller.dataStore.member.getMember(
              guildId: Snowflake(message.payload['guild_id']),
              memberId: Snowflake(message.payload['member']['user']['id']),
            ),
          ),
        _ => PrivateSelectContext(
            id: Snowflake(message.payload['id']),
            applicationId: Snowflake(message.payload['application_id']),
            token: message.payload['token'],
            version: message.payload['version'],
            customId: message.payload['data']['custom_id'],
            message: await marshaller.dataStore.message.getPrivateMessage(
              messageId: Snowflake(message.payload['message']['id']),
              channelId: Snowflake(message.payload['channel_id']),
            ),
            user: await marshaller.serializers.user.serializeRemote(message.payload['user'])),
      };

      switch (selectMenuType) {
        case ComponentType.channelSelectMenu:
          _dispatchChannelSelectMenu(ctx, message.payload, dispatch);
        case ComponentType.roleSelectMenu:
          _dispatchRoleSelectMenu(ctx, message.payload, dispatch);
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

        return marshaller.serializers.channels.serializeCache(rawChannel) as Future<T>;
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

      return marshaller.serializers.role.serializeCache(rawRole);
    }));

    dispatch(
        event: Event.serverRoleSelect,
        params: [ctx, resolvedRoles],
        constraint: (String? customId) => customId == ctx.customId);
  }
}
