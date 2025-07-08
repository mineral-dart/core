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

    int flags = 32768;
    if (ephemeral) {
      flags += MessageFlagType.ephemeral.value;
    }

    final payload = {
      'type': 4,
      'data': {'flags': flags, 'components': components}
    };

    final req = switch (files.isEmpty) {
      true => Request.json(
          endpoint: '/interactions/$id/$token/callback', body: payload),
      false => Request.formData(
          endpoint: '/interactions/$id/$token/callback',
          body: payload,
          files: files),
    };

    await _dataStore.client.post(req);
  }

  @override
  Future<void> editInteraction(
      Snowflake botId, String token, Map<String, dynamic> raw) async {
    final req = Request.json(
        endpoint: '/webhooks/$botId/$token/messages/@original', body: raw);
    await _dataStore.client.patch(req);
  }

  @override
  Future<void> deleteInteraction(Snowflake botId, String token) async {
    final req =
        Request.json(endpoint: '/webhooks/$botId/$token/messages/@original');
    await _dataStore.client.delete(req);
  }

  @override
  Future<void> noReplyInteraction(Snowflake id, String token) async {
    // await replyInteraction(id, token, {
    //   'type': InteractionCallbackType.deferredUpdateMessage.value,
    //   'data': {
    //     'flags': MessageFlagType.ephemeral.value,
    //   }
    // });
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
    // await replyInteraction(id, token, {
    //   'type': InteractionCallbackType.deferredUpdateMessage.value,
    //   'data': {
    //     'flags': MessageFlagType.ephemeral.value,
    //   }
    // });
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
