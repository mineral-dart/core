import 'package:mineral/api/common/snowflake.dart';
import 'package:mineral/api/server/auto_mod/auto_moderation.dart';
import 'package:mineral/infrastructure/internals/marshaller/marshaller.dart';

final class ModerationRuleManager {
  final MarshallerContract _marshaller;

  final Map<Snowflake, AutoModeration> _rules = {};
  Map<Snowflake, AutoModeration> get rules => _rules;

  ModerationRuleManager(this._marshaller);

  Future<void> createRule(AutoModeration rule) async {
  }
}
