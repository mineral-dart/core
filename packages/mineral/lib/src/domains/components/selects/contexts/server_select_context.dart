import 'package:mineral/api.dart';
import 'package:mineral/container.dart';
import 'package:mineral/contracts.dart';

final class ServerSelectContext extends ComponentContextBase
    implements SelectContext {
  DataStoreContract get _datastore => ioc.resolve<DataStoreContract>();

  final Snowflake? memberId;

  final Snowflake serverId;

  final Snowflake? messageId;

  final Snowflake? channelId;

  ServerSelectContext({
    required super.id,
    required super.applicationId,
    required super.token,
    required super.version,
    required super.customId,
    required this.serverId,
    required this.messageId,
    required this.memberId,
    required this.channelId,
  });

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
