import 'dart:async';

import 'package:mineral/api.dart';
import 'package:mineral/contracts.dart';
import 'package:mineral/services.dart';
import 'package:mineral/src/domains/common/utils/attachment.dart';
import 'package:mineral/src/domains/container/ioc_container.dart';

final class InteractionPart implements InteractionPartContract {
  DataStoreContract get _dataStore => ioc.resolve<DataStoreContract>();

  HttpClientStatus get status => _dataStore.client.status;

  @override
  Future<void> replyInteraction(Snowflake id, String token,
      MessageBuilder builder, bool isEphemeral) async {
    final (components, files) = makeAttachmentFromBuilder(builder);

    int flags = MessageFlagType.isComponentV2.value;
    if (isEphemeral) {
      flags += MessageFlagType.ephemeral.value;
    }

    final req = Request.auto(
      endpoint: '/interactions/$id/$token/callback',
      body: {
        'type': InteractionCallbackType.channelMessageWithSource.value,
        'data': {'flags': flags, 'components': components}
      },
      files: files,
    );

    await _dataStore.requestBucket.query<Map>(req).run(_dataStore.client.post);
  }

  @override
  Future<void> editInteraction(Snowflake id, String token,
      MessageBuilder builder, bool isEphemeral) async {
    final (components, files) = makeAttachmentFromBuilder(builder);

    int flags = MessageFlagType.isComponentV2.value;
    if (isEphemeral) {
      flags += MessageFlagType.ephemeral.value;
    }

    final req = Request.auto(
      endpoint: '/webhooks/$id/$token/messages/@original',
      body: {'flags': flags, 'components': components},
      files: files,
    );

    await _dataStore.requestBucket
        .query<Map<String, dynamic>>(req)
        .run(_dataStore.client.patch);
  }

  @override
  Future<void> deleteInteraction(Snowflake id, String token) async {
    final req =
        Request.json(endpoint: '/webhooks/$id/$token/messages/@original');
    await _dataStore.client.delete(req);
  }

  @override
  Future<void> noReplyInteraction(
      Snowflake id, String token, bool isEphemeral) async {
    final req = Request.json(
      endpoint: '/webhooks/$id/$token/messages/@original',
      body: {
        'type': InteractionCallbackType.deferredUpdateMessage.value,
        'data': {if (isEphemeral) 'flags': MessageFlagType.ephemeral.value}
      },
    );

    await _dataStore.client.post(req);
  }

  @override
  Future<void> createFollowup(Snowflake id, String token,
      MessageBuilder builder, bool isEphemeral) async {
    final (components, files) = makeAttachmentFromBuilder(builder);

    int flags = MessageFlagType.isComponentV2.value;
    if (isEphemeral) {
      flags += MessageFlagType.ephemeral.value;
    }

    final req = Request.auto(
      endpoint: '/webhooks/$id/$token',
      body: {
        'type': InteractionCallbackType.channelMessageWithSource.value,
        'data': {'flags': flags, 'components': components}
      },
      files: files,
    );

    await _dataStore.requestBucket.query<Map>(req).run(_dataStore.client.post);
  }

  @override
  Future<void> editFollowup(Snowflake botId, String token, Snowflake messageId,
      MessageBuilder builder, bool isEphemeral) async {
    final (components, files) = makeAttachmentFromBuilder(builder);

    int flags = MessageFlagType.isComponentV2.value;
    if (isEphemeral) {
      flags += MessageFlagType.ephemeral.value;
    }

    final req = Request.auto(
      endpoint: '/webhooks/$botId/$token/messages/$messageId',
      body: {'flags': flags, 'components': components},
      files: files,
    );

    await _dataStore.requestBucket.query<Map>(req).run(_dataStore.client.patch);
  }

  @override
  Future<void> waitInteraction(Snowflake id, String token) async {
    final req = Request.json(
      endpoint: '/webhooks/$id/$token',
      body: {
        'type': InteractionCallbackType.deferredUpdateMessage.value,
        'data': {'flags': MessageFlagType.ephemeral.value}
      },
    );

    await _dataStore.requestBucket.query<Map>(req).run(_dataStore.client.post);
  }

  @override
  Future<void> deleteFollowup(
      Snowflake botId, String token, Snowflake messageId) async {
    final req =
        Request.json(endpoint: '/webhooks/$botId/$token/messages/$messageId');
    await _dataStore.client.delete(req);
  }

  @override
  Future<void> sendModal(
    Snowflake id,
    String token,
    ModalBuilder modal,
  ) async {
    final req =
        Request.json(endpoint: '/interactions/$id/$token/callback', body: {
      'type': InteractionCallbackType.modal.value,
      'data': modal.build(),
    });
    await _dataStore.client.post(req);
  }
}
