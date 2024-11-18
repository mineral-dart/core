import 'dart:async';

import 'package:mineral/container.dart';
import 'package:mineral/services.dart';
import 'package:mineral/src/api/common/components/dialogs/dialog_builder.dart';
import 'package:mineral/src/api/common/snowflake.dart';
import 'package:mineral/src/api/common/types/message_flag_type.dart';
import 'package:mineral/src/infrastructure/internals/datastore/data_store.dart';
import 'package:mineral/src/infrastructure/internals/datastore/data_store_part.dart';
import 'package:mineral/src/infrastructure/internals/interactions/types/interaction_callback_type.dart';

final class InteractionPart implements DataStorePart {
  DataStoreContract get _dataStore => ioc.resolve<DataStoreContract>();

  HttpClientStatus get status => _dataStore.client.status;

  Future<void> replyInteraction(
      Snowflake id, String token, Map<String, dynamic> raw) async {
    await _dataStore.client
        .post('/interactions/$id/$token/callback', body: raw);
  }

  Future<void> editInteraction(
      Snowflake botId, String token, Map<String, dynamic> raw) async {
    await _dataStore.client
        .patch('/webhooks/$botId/$token/messages/@original', body: raw);
  }

  Future<void> deleteInteraction(Snowflake botId, String token) async {
    await _dataStore.client
        .delete('/webhooks/$botId/$token/messages/@original');
  }

  Future<void> noReplyInteraction(Snowflake id, String token) async {
    await replyInteraction(id, token, {
      'type': InteractionCallbackType.deferredUpdateMessage.value,
      'data': {
        'flags': MessageFlagType.ephemeral.value,
      }
    });
  }

  Future<void> followUpInteraction(
      Snowflake botId, String token, Map<String, dynamic> raw) async {
    await _dataStore.client.post('/webhooks/$botId/$token', body: raw);
  }

  Future<void> editFollowUpInteraction(Snowflake botId, String token,
      Snowflake messageId, Map<String, dynamic> raw) async {
    await _dataStore.client
        .patch('/webhooks/$botId/$token/messages/$messageId', body: raw);
  }

  Future<void> deleteFollowUpInteraction(
      Snowflake botId, String token, Snowflake messageId) async {
    await _dataStore.client
        .delete('/webhooks/$botId/$token/messages/$messageId');
  }

  Future<void> waitInteraction(Snowflake id, String token) async {
    await replyInteraction(id, token, {
      'type': InteractionCallbackType.deferredUpdateMessage.value,
      'data': {
        'flags': MessageFlagType.ephemeral.value,
      }
    });
  }

  Future<void> editWaitInteraction(Snowflake botId, String token,
      Snowflake messageId, Map<String, dynamic> raw) async {
    await _dataStore.client
        .patch('/webhooks/$botId/$token/messages/$messageId', body: raw);
  }

  Future<void> deleteWaitInteraction(
      Snowflake botId, String token, Snowflake messageId) async {
    await _dataStore.client
        .delete('/webhooks/$botId/$token/messages/$messageId');
  }

  Future<void> sendDialog(
      Snowflake id, String token, DialogBuilder dialog) async {
    await _dataStore.client.post('/interactions/$id/$token/callback', body: {
      'type': InteractionCallbackType.modal.value,
      'data': dialog.toJson(),
    });
  }
}
