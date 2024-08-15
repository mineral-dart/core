import 'package:mineral/api/common/bot.dart';
import 'package:mineral/api/common/components/dialogs/dialog_builder.dart';
import 'package:mineral/api/common/components/message_component.dart';
import 'package:mineral/api/common/embed/message_embed.dart';
import 'package:mineral/api/common/snowflake.dart';
import 'package:mineral/api/common/types/message_flag_type.dart';
import 'package:mineral/infrastructure/commons/helper.dart';
import 'package:mineral/infrastructure/internals/container/ioc_container.dart';
import 'package:mineral/infrastructure/internals/datastore/data_store.dart';
import 'package:mineral/infrastructure/internals/interactions/types/interaction_callback_type.dart';
import 'package:mineral/infrastructure/internals/interactions/types/interaction_contract.dart';
import 'package:mineral/infrastructure/internals/marshaller/marshaller.dart';

final class Interaction implements InteractionContract {
  final String _token;
  final Snowflake _id;
  final Snowflake _botId = ioc.resolve<Bot>().id;

  DataStoreContract get _datastore => ioc.resolve<DataStoreContract>();

  MarshallerContract get _marshaller => ioc.resolve<MarshallerContract>();

  Interaction(this._token, this._id);

  @override
  Future<InteractionContract> reply(
      {String? content,
      List<MessageEmbed> embeds = const [],
      List<MessageComponent> components = const [],
      bool ephemeral = false}) async {
    await _datastore.interaction.replyInteraction(_id, _token, {
      'type': InteractionCallbackType.channelMessageWithSource.value,
      'data': {
        'content': content,
        'embeds': await Helper.createOrNullAsync(
            field: embeds,
            fn: () async => embeds.map(_marshaller.serializers.embed.deserialize).toList()),
        'components': Helper.createOrNull(
            field: components.isNotEmpty, fn: () => components.map((e) => e.toJson()).toList()),
        'flags': ephemeral ? MessageFlagType.ephemeral.value : MessageFlagType.none.value,
      }
    });

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
          fn: () async => embeds.map(_marshaller.serializers.embed.deserialize).toList()),
      'components': Helper.createOrNull(
          field: components.isNotEmpty, fn: () => components.map((e) => e.toJson()).toList()),
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
          fn: () async => embeds.map(_marshaller.serializers.embed.deserialize).toList()),
      'components': Helper.createOrNull(
          field: components.isNotEmpty, fn: () => components.map((e) => e.toJson()).toList()),
      'flags': ephemeral ? MessageFlagType.ephemeral.value : MessageFlagType.none.value,
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
          fn: () async => embeds.map(_marshaller.serializers.embed.deserialize).toList()),
      'components': Helper.createOrNull(
          field: components.isNotEmpty, fn: () => components.map((e) => e.toJson()).toList()),
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
          fn: () async => embeds.map(_marshaller.serializers.embed.deserialize).toList()),
      'components': Helper.createOrNull(
          field: components.isNotEmpty, fn: () => components.map((e) => e.toJson()).toList()),
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
