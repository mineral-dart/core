import 'dart:core';

import 'package:http/http.dart';
import 'package:mineral/api.dart';
import 'package:mineral/core.dart';
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

  Future<void> reply ({ String? content, List<MessageEmbed>? embeds, List<Row>? components, bool? tts, bool? private }) async {
    Http http = ioc.singleton(ioc.services.http);

    List<dynamic> embedList = [];
    if (embeds != null) {
      for (MessageEmbed element in embeds) {
        embedList.add(element.toJson());
      }
    }

    List<dynamic> componentList = [];
    if (components != null) {
      for (Row element in components) {
        componentList.add(element.toJson());
      }
    }

    Response response = await http.post(url: "/interactions/$id/$token/callback", payload: {
      'type': InteractionCallbackType.channelMessageWithSource.value,
      'data': {
        'tts': tts ?? false,
        'content': content,
        'embeds': embeds != null ? embedList : [],
        'components': components != null ? componentList : [],
        'flags': private != null && private == true ? 1 << 6 : null,
      }
    });

    print(response.body);
  }

  factory CommandInteraction.from({ required User user, required dynamic payload }) {
    return CommandInteraction(
      id: payload['id'],
      applicationId: payload['application_id'],
      type: InteractionType.values.firstWhere((type) => type.value == payload['type']),
      identifier: payload['data']['name'],
      version: payload['version'],
      token: payload['token'],
      user: user,
    );
  }
}
