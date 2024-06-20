import 'dart:io';

import 'package:mineral/api/common/snowflake.dart';
import 'package:mineral/api/server/auto_mod/auto_moderation.dart';
import 'package:mineral/infrastructure/internals/datastore/data_store_part.dart';
import 'package:mineral/infrastructure/internals/http/discord_header.dart';
import 'package:mineral/infrastructure/kernel/kernel.dart';
import 'package:mineral/infrastructure/services/http/http_client_status.dart';
import 'package:mineral/infrastructure/services/http/http_request_option.dart';

final class AutoModPart implements DataStorePart {
  final KernelContract _kernel;

  HttpClientStatus get status => _kernel.dataStore.client.status;

  AutoModPart(this._kernel);

  Future<List<AutoModeration>> getRules(
      {required Snowflake id, required Map<String, dynamic> payload, String? reason}) async {
    final response = await _kernel.dataStore.client.get('/guilds/$id/auto-moderation/rules',
        option: HttpRequestOptionImpl(headers: {DiscordHeader.auditLogReason(reason)}));

    return switch (response.statusCode) {
      final int code when status.isSuccess(code) => Future.wait(List.from(response.body).map(
          (element) async => _kernel.marshaller.serializers.autoModeration.serialize(element))),
      final int code when status.isError(code) => throw HttpException(response.body),
      _ => throw Exception('Unknown status code: ${response.statusCode}'),
    };
  }

  Future<AutoModeration> create(
      {required Snowflake id, required Map<String, dynamic> payload, String? reason}) async {
    final response = await _kernel.dataStore.client.post('/guilds/$id/auto-moderation/rules',
        body: payload,
        option: HttpRequestOptionImpl(headers: {DiscordHeader.auditLogReason(reason)}));

    return switch (response.statusCode) {
      final int code when status.isSuccess(code) =>
        await _kernel.marshaller.serializers.autoModeration.serialize(response.body),
      final int code when status.isError(code) => throw HttpException(response.body),
      _ => throw Exception('Unknown status code: ${response.statusCode}'),
    };
  }
}
