import 'package:mineral/api.dart';
import 'package:mineral/container.dart';
import 'package:mineral/contracts.dart';
import 'package:mineral/src/domains/commons/utils/helper.dart';

final class Interaction implements InteractionContract {
  final String _token;
  final Snowflake _id;
  final Snowflake _botId = ioc.resolve<Bot>().id;

  DataStoreContract get _datastore => ioc.resolve<DataStoreContract>();

  MarshallerContract get _marshaller => ioc.resolve<MarshallerContract>();

  Interaction(this._token, this._id);

  @override
  Future<InteractionContract> reply(
      {required MessageComponentBuilder builder,
      bool ephemeral = false}) async {
    await _datastore.interaction
        .replyInteraction(_id, _token, builder, ephemeral);

    return this;
  }

  @override
  Future<InteractionContract> editReply(
      {String? content,
      List<MessageEmbed> embeds = const [],
      List<MessageComponent> components = const []}) async {
    await _datastore.interaction.editInteraction(_botId, _token, {
      'content': content,
      'embeds': await Helper.createOrNullAsync(
          field: embeds,
          fn: () async =>
              embeds.map(_marshaller.serializers.embed.deserialize).toList()),
      'components': Helper.createOrNull(
          field: components.isNotEmpty,
          fn: () => components.map((e) => e.toJson()).toList()),
    });
    return this;
  }

  @override
  Future<void> deleteReply() async {
    await _datastore.interaction.deleteInteraction(_botId, _token);
  }

  @override
  Future<void> noReply() async {
    await _datastore.interaction.noReplyInteraction(_id, _token);
  }

  @override
  Future<InteractionContract> followUp(
      {String? content,
      List<MessageEmbed> embeds = const [],
      List<MessageComponent> components = const [],
      bool ephemeral = false}) async {
    await _datastore.interaction.followUpInteraction(_botId, _token, {
      'content': content,
      'embeds': await Helper.createOrNullAsync(
          field: embeds,
          fn: () async =>
              embeds.map(_marshaller.serializers.embed.deserialize).toList()),
      'components': Helper.createOrNull(
          field: components.isNotEmpty,
          fn: () => components.map((e) => e.toJson()).toList()),
      'flags': ephemeral
          ? MessageFlagType.ephemeral.value
          : MessageFlagType.none.value,
    });
    return this;
  }

  @override
  Future<InteractionContract> editFollowUp(
      {String? content,
      List<MessageEmbed> embeds = const [],
      List<MessageComponent> components = const [],
      bool ephemeral = false}) async {
    await _datastore.interaction.editFollowUpInteraction(_botId, _token, _id, {
      'content': content,
      'embeds': await Helper.createOrNullAsync(
          field: embeds,
          fn: () async =>
              embeds.map(_marshaller.serializers.embed.deserialize).toList()),
      'components': Helper.createOrNull(
          field: components.isNotEmpty,
          fn: () => components.map((e) => e.toJson()).toList()),
    });
    return this;
  }

  @override
  Future<void> deleteFollowUp() async {
    await _datastore.interaction.deleteFollowUpInteraction(_botId, _token, _id);
  }

  @override
  Future<InteractionContract> wait() async {
    await _datastore.interaction.waitInteraction(_id, _token);
    return this;
  }

  @override
  Future<InteractionContract> editWait(
      {String? content,
      List<MessageEmbed> embeds = const [],
      List<MessageComponent> components = const [],
      bool ephemeral = false}) async {
    await _datastore.interaction.editWaitInteraction(_botId, _token, _id, {
      'content': content,
      'embeds': await Helper.createOrNullAsync(
          field: embeds,
          fn: () async =>
              embeds.map(_marshaller.serializers.embed.deserialize).toList()),
      'components': Helper.createOrNull(
          field: components.isNotEmpty,
          fn: () => components.map((e) => e.toJson()).toList()),
    });
    return this;
  }

  @override
  Future<void> deleteDefer() async {
    await _datastore.interaction.deleteWaitInteraction(_botId, _token, _id);
  }

  @override
  Future<void> dialog(DialogBuilder dialog) async {
    await _datastore.interaction.sendDialog(_id, _token, dialog);
  }
}
