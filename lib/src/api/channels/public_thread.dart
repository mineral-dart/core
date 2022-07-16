import 'package:mineral/api.dart';
import 'package:mineral/core.dart';
import 'package:mineral/src/api/managers/webhook_manager.dart';

class PublicThread extends Channel {

  String? name;
  Snowflake? lastMessageId;
  DateTime? lastPinTimestamp;

  PublicThread({
    required Snowflake id,
    required Snowflake? guildId,
    required int? position,
    required String label,
    required Snowflake? applicationId,
    required Snowflake? parentId,
    required int? flags,
    required WebhookManager webhooks,
  }) : super(
    id: id,
    type: ChannelType.guildPublicThread,
    guildId: guildId,
    position: position,
    label: label,
    applicationId: applicationId,
    parentId: parentId,
    flags: flags,
    webhooks: webhooks,
  );

  Future<void> create (Snowflake message, String name) async {
    Http http = ioc.singleton(ioc.services.http);
    await http.post(url: '/channels/$id/messages/$message/threads', payload: {
      'name': name,
    });
  }

  factory PublicThread.from({ required dynamic payload }) {
    return PublicThread(
      id: payload['id'],
      guildId: payload['guild_id'],
      position: payload['position'],
      label: payload['name'],
      applicationId: payload['application_id'],
      parentId: payload['parent_id'],
      flags: payload['flags'],
      webhooks: payload['webhooks'],
    );
  }
}
