import 'package:mineral/api/common/bot.dart';
import 'package:mineral/api/common/embed/message_embed.dart';
import 'package:mineral/api/common/snowflake.dart';
import 'package:mineral/domains/types/flags_type.dart';
import 'package:mineral/domains/types/interaction_callback_type.dart';
import 'package:mineral/domains/types/interaction_contract.dart';
import 'package:mineral/infrastructure/commons/helper.dart';
import 'package:mineral/infrastructure/internals/container/ioc_container.dart';
import 'package:mineral/infrastructure/internals/datastore/data_store.dart';
import 'package:mineral/infrastructure/internals/datastore/parts/interaction_part.dart';
import 'package:mineral/infrastructure/internals/marshaller/marshaller.dart';

final class Interaction implements InteractionContract {
  final String _token;
  final Snowflake _id;
  final Snowflake _botId = ioc.resolve<Bot>().id;

  InteractionPart get dataStoreInteraction => ioc.resolve<DataStoreContract>().interaction;
  MarshallerContract get _marshaller => ioc.resolve<MarshallerContract>();

  Interaction(this._token, this._id);

  @override
  Future<InteractionContract> reply({String? content, List<MessageEmbed> embeds = const [], bool ephemeral = false}) async {
   await dataStoreInteraction.replyInteraction(_id, _token, {
      'type': InteractionCallbackType.channelMessageWithSource.value,
      'data': {
        'content': content,
        'embeds': await Helper.createOrNullAsync(field: embeds, fn: () async => embeds.map(_marshaller.serializers.embed.deserialize).toList()),
        'flags': ephemeral ? FlagsType.ephemeral.value : FlagsType.none.value,
      }
    });

    return this;
  }

  @override
  Future<InteractionContract> editReply({String? content, List<MessageEmbed> embeds = const [] }) async {
    await dataStoreInteraction.editInteraction(_botId, _token, {
      'content': content,
      'embeds': await Helper.createOrNullAsync(field: embeds, fn: () async => embeds.map(_marshaller.serializers.embed.deserialize).toList()),
    });
    return this;
  }

  @override
  Future<void> deleteReply() async {
    await dataStoreInteraction.deleteInteraction(_botId, _token);
  }

  @override
  Future<void> noReply() async {
    await dataStoreInteraction.noReplyInteraction(_id, _token);
  }

  @override
  Future<InteractionContract> followUp({String? content, List<MessageEmbed> embeds = const [], bool ephemeral = false}) async {
    await dataStoreInteraction.followUpInteraction(_botId, _token, {
      'content': content,
      'embeds': await Helper.createOrNullAsync(field: embeds, fn: () async => embeds.map(_marshaller.serializers.embed.deserialize).toList()),
      'flags': ephemeral ? FlagsType.ephemeral.value : FlagsType.none.value,
    });
    return this;
  }

  @override
  Future<InteractionContract> editFollowUp({String? content, List<MessageEmbed> embeds = const [], bool ephemeral = false}) async {
    await dataStoreInteraction.editFollowUpInteraction(_botId, _token, _id, {
      'content': content,
      'embeds': await Helper.createOrNullAsync(field: embeds, fn: () async => embeds.map(_marshaller.serializers.embed.deserialize).toList()),
    });
    return this;
  }

  @override
  Future<void> deleteFollowUp() async {
    await dataStoreInteraction.deleteFollowUpInteraction(_botId, _token, _id);
  }

  @override
  Future<InteractionContract> wait() async {
    await dataStoreInteraction.waitInteraction(_id, _token);
    return this;
  }

  @override
  Future<InteractionContract> editWait({String? content, List<MessageEmbed> embeds = const [], bool ephemeral = false}) async {
    await dataStoreInteraction.editWaitInteraction(_botId, _token, _id, {
      'content': content,
      'embeds': await Helper.createOrNullAsync(field: embeds, fn: () async => embeds.map(_marshaller.serializers.embed.deserialize).toList()),
    });
    return this;
  }

  @override
  Future<void> deleteDefer() async {
    await dataStoreInteraction.deleteWaitInteraction(_botId, _token, _id);
  }
}
