import 'dart:async';

import 'package:mineral/contracts.dart';
import 'package:mineral/services.dart';
import 'package:mineral/src/api/common/components/dialogs/dialog_builder.dart';
import 'package:mineral/src/api/common/snowflake.dart';
import 'package:mineral/src/api/common/types/message_flag_type.dart';
import 'package:mineral/src/domains/services/container/ioc_container.dart';

final class InteractionPart implements InteractionPartContract {
  DataStoreContract get _dataStore => ioc.resolve<DataStoreContract>();

  HttpClientStatus get status => _dataStore.client.status;

  @override
  Future<void> replyInteraction(
      Snowflake id, String token, Map<String, dynamic> raw) async {
    final req =
        Request.json(endpoint: '/interactions/$id/$token/callback', body: raw);
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
    await replyInteraction(id, token, {
      'type': InteractionCallbackType.deferredUpdateMessage.value,
      'data': {
        'flags': MessageFlagType.ephemeral.value,
      }
    });
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
    await replyInteraction(id, token, {
      'type': InteractionCallbackType.deferredUpdateMessage.value,
      'data': {
        'flags': MessageFlagType.ephemeral.value,
      }
    });
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
