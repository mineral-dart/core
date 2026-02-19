import 'package:mineral/contracts.dart';
import 'package:mineral/src/api/common/snowflake.dart';
import 'package:mineral/src/api/private/user.dart';
import 'package:mineral/src/domains/components/component_context_base.dart';
import 'package:mineral/src/domains/components/modal/modal_context.dart';

final class PrivateModalContext extends ComponentContextBase
    implements ModalContext {
  final User user;

  PrivateModalContext({
    required super.id,
    required super.applicationId,
    required super.token,
    required super.version,
    required super.customId,
    required this.user,
  });

  static Future<PrivateModalContext> fromMap(
      MarshallerContract marshaller, Map<String, dynamic> payload) async {
    return PrivateModalContext(
      customId: payload['data']['custom_id'],
      id: Snowflake.parse(payload['id']),
      applicationId: Snowflake.parse(payload['application_id']),
      token: payload['token'],
      version: payload['version'],
      user: await marshaller.serializers.user.serialize(payload['user']),
    );
  }
}
