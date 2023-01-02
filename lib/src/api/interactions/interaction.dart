import 'dart:io';

import 'package:http/http.dart';
import 'package:mineral/core.dart';
import 'package:mineral/core/api.dart';
import 'package:mineral/core/builders.dart';
import 'package:mineral/framework.dart';
import 'package:mineral_ioc/ioc.dart';
import 'package:path/path.dart';

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

  Snowflake get id => _id;
  String? get label => _label;
  Snowflake get applicationId => _applicationId;
  int get version => _version;
  InteractionType get type => InteractionType.values.firstWhere((element) => element.value == _typeId);
  String get token => _token;
  Guild? get guild => ioc.use<MineralClient>().guilds.cache.get(_guildId);

  User get user => _guildId != null
    ? guild!.members.cache.getOrFail(_userId).user
    : ioc.use<MineralClient>().users.cache.getOrFail(_userId);

  GuildMember? get member => guild?.members.cache.get(_userId);

  /// ### Responds to this by an [Message]
  ///
  /// Example :
  /// ```dart
  /// await interaction.reply(content: 'Hello ${interaction.user.username}');
  /// ```
  Future<Interaction> reply ({ String? content, List<EmbedBuilder>? embeds, List<RowBuilder>? components, List<MessageAttachmentBuilder>? attachments, bool? tts, bool? private }) async {
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

    dynamic payload = {
      'type': InteractionCallbackType.channelMessageWithSource.value,
      'data': {
        'tts': tts ?? false,
        'content': content,
        'embeds': embeds != null ? embeds.map((e) => e.toJson()).toList() : [],
        'components': components != null ? components.map((e) => e.toJson()).toList() : [],
        'flags': private != null && private == true ? 1 << 6 : null,
      }
    };

    if(attachments != null) {
      List<MultipartFile> files = [];
      List<dynamic> attachmentList = [];

      for (int i = 0; i < attachments.length; i++) {
        files.add(await MultipartFile.fromPath("files[$i]", join(Directory.current.path, attachments[i].url)));
        attachmentList.add(attachments[i].toJson(id: i));
      }

      payload['attachments'] = attachmentList;

      print(payload);
      await ioc.use<HttpService>().postWithFiles(url: "/interactions/$id/$token/callback", files: files, payload: payload);
      return this;
    }

    await ioc.use<HttpService>().post(url: "/interactions/$id/$token/callback", payload: payload);
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
    await ioc.use<HttpService>().post(url: "/interactions/$id/$token/callback", payload: {
      'type': InteractionCallbackType.modal.value,
      'data': modal.toJson(),
    });

    return this;
  }

  /// ### Responds to this by a deferred [Message] (Show a loading state to the user)
  Future<Interaction> deferredReply () async {
    await ioc.use<HttpService>().post(url: "/interactions/$id/$token/callback", payload: {
      'type': InteractionCallbackType.deferredChannelMessageWithSource.value
    });

    return this;
  }

  /// ### Edit original response to interaction
  Future<Interaction> updateReply({ String? content, List<EmbedBuilder>? embeds, List<RowBuilder>? components }) async {
    await ioc.use<HttpService>().patch(url: "/webhooks/$applicationId/$token/messages/@original", payload: {
      'content': content,
      'embeds': embeds != null ? embeds.map((e) => e.toJson()).toList() : [],
      'components': components != null ? components.map((e) => e.toJson()).toList() : [],
    });

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
    await ioc.use<HttpService>().destroy(url: "/webhooks/$applicationId/$token/messages/@original");
  }

  factory Interaction.from({ required dynamic payload }) {
    return Interaction(
      payload['id'],
      null,
      payload['application_id'],
      payload['version'],
      payload['type'],
      payload['token'],
      payload['member']?['user']?['id'],
      payload['guild_id'],
    );
  }
}
