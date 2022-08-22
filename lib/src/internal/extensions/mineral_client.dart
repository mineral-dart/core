import 'package:http/http.dart';
import 'package:mineral/api.dart';
import 'package:mineral/core.dart';

extension MineralClientExtension on MineralClient {
  Future<Response> sendMessage (dynamic channel, { String? content, List<EmbedBuilder>? embeds, List<RowBuilder>? components, bool? tts }) async {
    Http http = ioc.singleton(ioc.services.http);

    List<dynamic> embedList = [];
    if (embeds != null) {
      for (EmbedBuilder element in embeds) {
        embedList.add(element.toJson());
      }
    }

    List<dynamic> componentList = [];
    if (components != null) {
      for (RowBuilder element in components) {
        componentList.add(element.toJson());
      }
    }

    return await http.post(url: '/channels/${channel?.id}/messages', payload: {
      'tts': tts ?? false,
      'content': content,
      'embeds': embeds != null ? embedList : [],
      'components': components != null ? componentList : [],
    });
  }
}
