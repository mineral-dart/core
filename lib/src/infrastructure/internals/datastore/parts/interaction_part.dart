import 'dart:async';

import 'package:mineral/api.dart';
import 'package:mineral/contracts.dart';
import 'package:mineral/services.dart';
import 'package:mineral/src/domains/commons/utils/attachment.dart';
import 'package:mineral/src/domains/container/ioc_container.dart';

final class InteractionPart implements InteractionPartContract {
  DataStoreContract get _dataStore => ioc.resolve<DataStoreContract>();

  HttpClientStatus get status => _dataStore.client.status;

  @override
  Future<void> replyInteraction(Snowflake id, String token,
      MessageComponentBuilder builder, bool ephemeral) async {
    final (components, files) = makeAttachmentFromBuilder(builder);

    int flags = MessageFlagType.isComponentV2.value;
    if (ephemeral) {
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
      MessageComponentBuilder builder, bool ephemeral) async {
    final (components, files) = makeAttachmentFromBuilder(builder);

    int flags = MessageFlagType.isComponentV2.value;
    if (ephemeral) {
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
      Snowflake id, String token, bool ephemeral) async {
    final req = Request.json(
      endpoint: '/webhooks/$id/$token/messages/@original',
      body: {
        'type': InteractionCallbackType.deferredUpdateMessage.value,
        'data': {if (ephemeral) 'flags': MessageFlagType.ephemeral.value}
      },
    );

    await _dataStore.client.post(req);
  }

  @override
  Future<void> followUpInteraction(
      Snowflake botId, String token, Map<String, dynamic> raw) async {
    final req = Request.json(endpoint: '/webhooks/$botId/$token', body: raw);
    await _dataStore.client.post(req);
  }

  @override
  Future<void> editFollowUpInteraction(Snowflake botId, String token,
      Snowflake messageId, Map<String, dynamic> raw) async {
    final req = Request.json(
        endpoint: '/webhooks/$botId/$token/messages/$messageId', body: raw);
    await _dataStore.client.patch(req);
  }

  @override
  Future<void> deleteFollowUpInteraction(
      Snowflake botId, String token, Snowflake messageId) async {
    final req =
        Request.json(endpoint: '/webhooks/$botId/$token/messages/$messageId');
    await _dataStore.client.delete(req);
  }

  @override
  Future<void> waitInteraction(Snowflake id, String token) async {
    // Todo: Implement this
    throw UnimplementedError();
  }

  @override
  Future<void> editWaitInteraction(Snowflake botId, String token,
      Snowflake messageId, Map<String, dynamic> raw) async {
    final req = Request.json(
        endpoint: '/webhooks/$botId/$token/messages/$messageId', body: raw);
    await _dataStore.client.patch(req);
  }

  @override
  Future<void> deleteWaitInteraction(
      Snowflake botId, String token, Snowflake messageId) async {
    final req =
        Request.json(endpoint: '/webhooks/$botId/$token/messages/$messageId');
    await _dataStore.client.delete(req);
  }

  @override
  Future<void> sendDialog(
      Snowflake id, String token, DialogBuilder dialog) async {
    final req =
        Request.json(endpoint: '/interactions/$id/$token/callback', body: {
      'type': InteractionCallbackType.modal.value,
      'data': dialog.toJson(),
    });
    await _dataStore.client.post(req);
  }
}
