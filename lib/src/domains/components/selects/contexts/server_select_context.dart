import 'package:mineral/api.dart';
import 'package:mineral/container.dart';
import 'package:mineral/contracts.dart';
import 'package:mineral/src/infrastructure/internals/interactions/interaction.dart';

final class ServerSelectContext implements SelectContext {
  DataStoreContract get _datastore => ioc.resolve<DataStoreContract>();

  @override
  final Snowflake id;

  @override
  final Snowflake applicationId;

  @override
  final String token;

  @override
  final int version;

  @override
  final String customId;

  final Snowflake? memberId;

  final Snowflake serverId;

  final Snowflake? messageId;

  final Snowflake? channelId;

  late final InteractionContract interaction;

  ServerSelectContext({
    required this.id,
    required this.applicationId,
    required this.token,
    required this.version,
    required this.customId,
    required this.serverId,
    required this.messageId,
    required this.memberId,
    required this.channelId,
  }) {
    interaction = Interaction(token, id);
  }

  Future<Member?> resolveMember({bool force = false}) async {
    if (memberId == null) {
      return null;
    }

    return _datastore.member.get(serverId.value, memberId!.value, force);
  }

  Future<ServerMessage?> resolveMessage({bool force = false}) async {
    if (messageId == null) {
      return null;
    }

    return _datastore.message
        .get<ServerMessage>(serverId.value, messageId!.value, force);
  }

  Future<T?> resolveChannel<T extends Channel>({bool force = false}) async {
    if (channelId == null) {
      return null;
    }

    return _datastore.channel.get<T>(channelId!.value, force);
  }

  Future<Server?> resolveServer({bool force = false}) =>
      _datastore.server.get(serverId.value, force);

  static Future<ServerSelectContext> fromMap(
      DataStoreContract datastore, Map<String, dynamic> payload) async {
    return ServerSelectContext(
      customId: payload['data']['custom_id'],
      id: Snowflake.parse(payload['id']),
      applicationId: Snowflake.parse(payload['application_id']),
      token: payload['token'],
      version: payload['version'],
      messageId: Snowflake.parse(payload['message']['id']),
      memberId: Snowflake.parse(payload['member']['user']['id']),
      serverId: Snowflake.parse(payload['guild_id']),
      channelId: Snowflake.parse(payload['channel_id']),
    );
  }
}
