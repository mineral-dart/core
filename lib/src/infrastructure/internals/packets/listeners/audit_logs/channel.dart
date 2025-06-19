import 'package:mineral/api.dart';
import 'package:mineral/container.dart';
import 'package:mineral/contracts.dart';
import 'package:mineral/src/api/server/audit_log/audit_log.dart';

Future<AuditLog> channelCreateAuditLogHandler(Map<String, dynamic> json) async {
  final datastore = ioc.resolve<DataStoreContract>();
  final channel = await datastore.channel.get(json['target_id'], false);

  return ChannelCreateAuditLogAction(
      serverId: Snowflake.parse(json['guild_id']),
      userId: Snowflake.parse(json['user_id']),
      channel: channel!);
}

Future<AuditLog> channelUpdateAuditLogHandler(Map<String, dynamic> json) async {
  final datastore = ioc.resolve<DataStoreContract>();
  final channel = await datastore.channel.get(json['target_id'], false);

  return ChannelUpdateAuditLogAction(
      serverId: Snowflake.parse(json['guild_id']),
      userId: Snowflake.parse(json['user_id']),
      channel: channel!,
      changes: json['changes'].map((e) => Change.fromJson(e)).toList());
}

Future<AuditLog> channelDeleteAuditLogHandler(Map<String, dynamic> json) async {
  return ChannelDeleteAuditLogAction(
      serverId: Snowflake.parse(json['guild_id']),
      userId: Snowflake.parse(json['user_id']),
      channelId: Snowflake.parse(json['target_id']),
      changes: json['changes'].map((e) => Change.fromJson(e)).toList());
}
