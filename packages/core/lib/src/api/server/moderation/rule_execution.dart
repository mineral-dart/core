import 'package:mineral/api.dart';
import 'package:mineral/src/api/server/moderation/enums/trigger_type.dart';

final class RuleExecution {
  final Snowflake ruleId;
  final Snowflake? channelId;
  final Snowflake? messageId;

  final Server server;
  final Member member;
  final Action action;
  final TriggerType triggerType;

  final String content;
  final String? matchedContent;
  final String? matchedKeyword;

  RuleExecution({
    required this.ruleId,
    required this.channelId,
    required this.messageId,
    required this.server,
    required this.member,
    required this.action,
    required this.triggerType,
    required this.content,
    this.matchedContent,
    this.matchedKeyword,
  });
}
