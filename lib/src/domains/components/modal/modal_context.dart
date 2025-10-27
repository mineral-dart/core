import 'package:mineral/src/api/common/snowflake.dart';
import 'package:mineral/src/domains/components/component_context.dart';

abstract interface class ModalContext implements ComponentContext {
  Snowflake get id;
  Snowflake get applicationId;
  String get token;
  int get version;
  String get customId;
}
