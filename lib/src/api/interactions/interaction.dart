import 'package:mineral/api.dart';
import 'package:mineral/core.dart';

enum InteractionCallbackType {
  pong(1),
  channelMessageWithSource(4),
  deferredChannelMessageWithSource(5),
  deferredUpdateMessage(6),
  updateMessage(7),
  applicationCommandAutocompleteResult(8),
  modal(9);

  final int value;
  const InteractionCallbackType(this.value);
}

class Interaction {
  Snowflake _id;
  Snowflake _applicationId;
  int _version;
  InteractionType _type;
  String _token;
  User _user;
  Guild? _guild;
  GuildMember? _member;

  Interaction(this._id, this._applicationId, this._version, this._type, this._token, this._user, this._guild, this._member);

  Snowflake get id => _id;
  Snowflake get applicationId => _applicationId;
  int get version => _version;
  InteractionType get type => _type;
  String get token => _token;
  User get user => _user;
  Guild? get guild => _guild;
  GuildMember? get member => _member;

  /// ### Responds to this by an [Message]
  ///
  /// Example :
  /// ```dart
  /// await interaction.reply(content: 'Hello ${interaction.user.username}');
  /// ```
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

    await http.post(url: "/interactions/$id/$token/callback", payload: {
      'type': InteractionCallbackType.channelMessageWithSource.value,
      'data': {
        'tts': tts ?? false,
        'content': content,
        'embeds': embeds != null ? embedList : [],
        'components': components != null ? componentList : [],
        'flags': private != null && private == true ? 1 << 6 : null,
      }
    });
  }

  /// ### Responds to this by an [Modal]
  ///
  /// Example :
  /// ```dart
  /// Modal modal = Modal(customId: 'modal', label: 'My modal')
  ///   .addInput(customId: 'my_text', label: 'First text')
  ///   .addParagraph(customId: 'my_paragraph', label: 'Second text');
  ///
  /// await interaction.modal(modal);
  /// ```
  Future<void> modal (Modal modal) async {
    Http http = ioc.singleton(ioc.services.http);

    await http.post(url: "/interactions/$id/$token/callback", payload: {
      'type': InteractionCallbackType.modal.value,
      'data': modal.toJson(),
    });
  }

  factory Interaction.from({ required User user, required Guild? guild, required dynamic payload }) {
    return Interaction(
      payload['id'],
      payload['application_id'],
      payload['version'],
      InteractionType.values.firstWhere((element) => element.value == payload['type']),
      payload['token'],
      user,
      guild,
      guild?.members.cache.getOrFail(user.id)
    );
  }
}
