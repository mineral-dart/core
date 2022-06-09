import 'package:mineral/api.dart';
import 'package:mineral/src/api/interactions/interaction.dart';

class CommandInteraction extends Interaction {
  Snowflake id;
  String identifier;
  Map<String, dynamic> data = {};

  CommandInteraction({
    required this.identifier,
    required this.id,
    required InteractionType type,
    required Snowflake applicationId,
    required int version,
    required String token,
    required User user
  }) : super(version: version, token: token, type: type, user: user, applicationId: applicationId);

  T? getChannel<T extends Channel> (String optionName) {
    return guild?.channels.cache.get(data[optionName]['value']);
  }

  int? getInteger (String optionName) {
    return data[optionName]['value'];
  }

  String? getString (String optionName) {
    return data[optionName]['value'];
  }

  GuildMember? getMember (String optionName) {
    return guild?.members.cache.get(data[optionName]['value']);
  }

  bool? getBoolean (String optionName) {
    return data[optionName]['value'];
  }

  Role? getRole (String optionName) {
    return guild?.roles.cache.get(data[optionName]['value']);
  }

  T? getChoice<T> (String optionName) {
    return data[optionName]['value'];
  }

  dynamic getMentionable (String optionName) {
    return data[optionName]['value'];
  }

  factory CommandInteraction.from({ required User user, required dynamic payload }) {
    return CommandInteraction(
      id: payload['data']['id'],
      applicationId: payload['application_id'],
      type: InteractionType.values.firstWhere((type) => type.value == payload['type']),
      identifier: payload['data']['name'],
      version: payload['version'],
      token: payload['token'],
      user: user,
    );
  }
}
