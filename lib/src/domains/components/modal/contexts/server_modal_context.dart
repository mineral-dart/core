import 'package:mineral/contracts.dart';
import 'package:mineral/src/api/common/snowflake.dart';
import 'package:mineral/src/api/server/member.dart';
import 'package:mineral/src/domains/components/component_context_base.dart';
import 'package:mineral/src/domains/components/modal/modal_context.dart';

final class ServerModalContext extends ComponentContextBase
    implements ModalContext {
  final Member member;

  ServerModalContext({
    required super.id,
    required super.applicationId,
    required super.token,
    required super.version,
    required super.customId,
    required this.member,
  });

  static Future<ServerModalContext> fromMap(
      DataStoreContract datastore, Map<String, dynamic> payload) async {
    return ServerModalContext(
      customId: payload['data']['custom_id'],
      id: Snowflake.parse(payload['id']),
      applicationId: Snowflake.parse(payload['application_id']),
      token: payload['token'],
      version: payload['version'],
      member: (await datastore.member.get(
        payload['guild_id'],
        payload['member']['user']['id'],
        false,
      ))!,
    );
  }
}
