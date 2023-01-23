import 'package:mineral/core/api.dart';

class GlobalCommandInteraction extends CommandInteraction {
  GlobalCommandInteraction(
    super.id,
    super.label,
    super.applicationId,
    super.version,
    super.typeId,
    super.token,
    super.userId,
    super.guildId,
    super.identifier,
    super.channelId,
    super.data,
    super.params
  );

  @override
  PartialChannel? get channel => super.channel as PartialChannel;

  factory GlobalCommandInteraction.fromPayload(dynamic payload) {
    final Map<String, dynamic> params = {};
    void walk (List<dynamic> options) {
      for (final option in options) {
        if (option['options'] != null) {
          walk(option['options']);
        } else {
          params.putIfAbsent(option['name'], () => option['value']);
        }
      }
    }

    if (payload['data']?['options'] != null) {
      walk(payload['data']['options']);
    }

    return GlobalCommandInteraction(
        payload['id'],
        payload['data']['name'],
        payload['application_id'],
        payload['version'],
        payload['type'],
        payload['token'],
        payload['guild_id'] == null ? payload['user']['id'] : payload['member']?['user']?['id'],
        payload['guild_id'],
        payload['data']['name'],
        payload['channel_id'],
        payload['data'],
        params
    );
  }
}
