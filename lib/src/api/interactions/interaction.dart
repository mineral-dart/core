import 'package:mineral/core.dart';
import 'package:mineral/core/api.dart';
import 'package:mineral/core/builders.dart';
import 'package:mineral/framework.dart';
import 'package:mineral/src/api/messages/message_parser.dart';
import 'package:mineral_ioc/ioc.dart';

/// ### Interaction Type
///  - [ping] : A ping
///  - [channelMessageWithSource] : A message component
///  - [deferredChannelMessageWithSource] : A deferred message component
///  - [deferredUpdateMessage] : A deferred message update
///  - [updateMessage] : A message update
///  - [applicationCommandAutocompleteResult] : A command autocomplete result
///  - [modal] : A modal
///
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

class Interaction  {
  Snowflake _id;
  String? _label;
  Snowflake _applicationId;
  int _version;
  int _typeId;
  String _token;
  Snowflake? _userId;
  Snowflake? _guildId;

  Interaction(this._id, this._label, this._applicationId, this._version, this._typeId, this._token, this._userId, this._guildId);

  /// Get id [Snowflake] of this
  Snowflake get id => _id;

  /// Get label [String] of this
  String? get label => _label;

  /// Get application id [Snowflake] of this
  Snowflake get applicationId => _applicationId;

  /// Get version [int] of this
  int get version => _version;

  /// Get type [InteractionType] of this
  InteractionType get type => InteractionType.values.firstWhere((element) => element.value == _typeId);

  /// Get token [String] of this
  String get token => _token;

  /// Get guild [Guild] of this
  Guild? get guild => ioc.use<MineralClient>().guilds.cache.get(_guildId);

  /// Get user [User] of this
  User get user => _guildId != null
    ? guild!.members.cache.getOrFail(_userId).user
    : ioc.use<MineralClient>().users.cache.getOrFail(_userId);

  /// Get member [GuildMember] of this
  GuildMember? get member => guild?.members.cache.get(_userId);

  /// ### Responds to this by an [Message]
  ///
  /// Example :
  /// ```dart
  /// await interaction.reply(content: 'Hello ${interaction.user.username}');
  /// ```
  Future<Interaction> reply ({ String? content, List<EmbedBuilder>? embeds, ComponentBuilder? components, List<AttachmentBuilder>? attachments, bool? tts, bool? private }) async {
    dynamic messagePayload = MessageParser(content, embeds, components, attachments, tts).toJson();

    dynamic payload = {
      'type': InteractionCallbackType.channelMessageWithSource.value,
      'data': {
        ...messagePayload['payload'],
        'flags': private != null && private == true ? 1 << 6 : null
      }
    };

    await ioc.use<DiscordApiHttpService>().post(url: "/interactions/$id/$token/callback")
      .files(messagePayload['files'])
      .payload(payload)
      .build();

    return this;
  }

  /// ### Responds to this by an [ModalBuilder]
  ///
  /// Example :
  /// ```dart
  /// Modal modal = Modal(customId: 'modal', label: 'My modal')
  ///   .addInput(customId: 'my_text', label: 'First text')
  ///   .addParagraph(customId: 'my_paragraph', label: 'Second text');
  ///
  /// await interaction.modal(modal);
  /// ```
  Future<Interaction> modal (ModalBuilder modal) async {
    await ioc.use<DiscordApiHttpService>().post(url: "/interactions/$id/$token/callback")
      .payload({ 'type': InteractionCallbackType.modal.value, 'data': modal.toJson() })
      .build();

    return this;
  }

  /// ### Responds to this by a deferred [Message] (Show a loading state to the user)
  Future<Interaction> deferredReply ({ bool private = false }) async {
    await ioc.use<DiscordApiHttpService>().post(url: "/interactions/$id/$token/callback")
        .payload({
          'type': InteractionCallbackType.deferredChannelMessageWithSource.value,
          'data': {
            'flags': private ? 1 << 6 : null
          }
        }).build();

    return this;
  }

  /// ### Edit original response to interaction
  ///
  /// Example :
  /// ```dart
  /// await interaction.updateReply(content: 'Hello ${interaction.user.username}');
  /// ```
  Future<Interaction> updateReply ({ String? content, List<EmbedBuilder>? embeds, ComponentBuilder? components, List<AttachmentBuilder>? attachments }) async {
    dynamic messagePayload = MessageParser(content, embeds, components, attachments, null).toJson();

    await ioc.use<DiscordApiHttpService>().patch(url: "/webhooks/$applicationId/$token/messages/@original")
      .files(messagePayload['files'])
      .payload(messagePayload['payload'])
      .build();

    return this;
  }

  /// ### Delete original response to interaction
  ///
  /// Example :
  /// ```dart
  /// await interaction.reply(content: 'Foo', private: true);
  ///
  /// await Future.delayed(Duration(seconds: 5), () async => {
  ///   await interaction.delete();
  /// });
  /// ```
  Future<void> delete () async {
    await ioc.use<DiscordApiHttpService>()
      .destroy(url: "/webhooks/$applicationId/$token/messages/@original")
      .build();
  }

  /// ### Shows no response (and error)
  ///
  /// Example :
  /// ```dart
  /// await interaction.noReply();
  ///  ```
  Future<void> noReply ({ bool private = false }) async {
    await ioc.use<DiscordApiHttpService>().post(url: "/interactions/$id/$token/callback")
        .payload({
          'type': InteractionCallbackType.deferredUpdateMessage.value,
          'data': {
            'flags': private ? 1 << 6 : null
          }
        }).build();
  }
  factory Interaction.from({ required dynamic payload }) {
    return Interaction(
      payload['id'],
      null,
      payload['application_id'],
      payload['version'],
      payload['type'],
      payload['token'],
      payload['member']?['user']?['id'] ?? payload['user']?['id'],
      payload['guild_id'],
    );
  }
}
