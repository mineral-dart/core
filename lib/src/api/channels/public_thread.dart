import 'package:mineral/api.dart';
import 'package:mineral/core.dart';


class PublicThread extends Channel {
  Channel? _parent;
  Snowflake? _lastMessageId;
  DateTime? _lastPinTimestamp;

  PublicThread(
    super._id,
    super._type,
    super._position,
    super._label,
    super._applicationId,
    super._flags,
    super._webhooks,
    super._permissionOverwrites,
    super._guild,
    this._parent,
    this._lastMessageId,
    this._lastPinTimestamp,
  );

  @override
  Channel? get parent => _parent;

  Snowflake? get lastMessageId => _lastMessageId;
  DateTime? get lastPinTimestamp => _lastPinTimestamp;

  Future<void> create (Snowflake message, String name) async {
    Http http = ioc.singleton(ioc.services.http);
    await http.post(url: '/channels/$id/messages/$message/threads', payload: {
      'name': name,
    });
  }

  factory PublicThread.from({ required dynamic payload }) {
    MineralClient client = ioc.singleton(ioc.services.client);

    Guild? guild = client.guilds.cache.get(payload['guild_id']);
    Channel? parent = guild?.channels.cache.get(payload['parent_id']);

    return PublicThread(
      payload['id'],
      ChannelType.guildPublicThread,
      payload['position'],
      payload['name'],
      payload['application_id'],
      payload['flags'],
      payload['webhooks'],
      null,
      guild,
      parent,
      payload['last_message_id'],
      payload['last_pin_message'],
    );
  }
}
