import 'package:mineral/core/api.dart';

class GuildCommandInteraction extends CommandInteraction {
  GuildCommandInteraction(
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

  /// Get channel [TextBasedChannel] of this
  @override
  TextBasedChannel? get channel => super.channel as TextBasedChannel;

  factory GuildCommandInteraction.fromPayload(dynamic payload) {
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

    return GuildCommandInteraction(
        payload['id'],
        payload['data']['name'],
        payload['application_id'],
        payload['version'],
        payload['type'],
        payload['token'],
        payload['member']?['user']?['id'] ?? payload['user']?['id'],
        payload['guild_id'],
        payload['data']['name'],
        payload['channel_id'],
        payload['data'],
        params
    );
  }
}
