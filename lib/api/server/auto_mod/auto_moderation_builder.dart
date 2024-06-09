import 'package:mineral/api/common/snowflake.dart';
import 'package:mineral/api/server/auto_mod/auto_moderation_action.dart';
import 'package:mineral/api/server/auto_mod/auto_moderation_trigger.dart';
import 'package:mineral/api/server/auto_mod/enums/event_type.dart';

final class AutoModerationBuilder<T extends AutoModerationTrigger> {
  String? name;
  EventType? eventType;
  T? trigger;
  bool isEnabled = false;
  List<AutoModerationAction> actions = [];
  List<Snowflake> exemptRoles = [];
  List<Snowflake> exemptChannels = [];

  AutoModerationBuilder<T> setName(String name) {
    this.name = name;
    return this;
  }

  AutoModerationBuilder<T> setEventType(EventType eventType) {
    this.eventType = eventType;
    return this;
  }

  AutoModerationBuilder<T> setTrigger(T trigger) {
    this.trigger = trigger;
    return this;
  }

  AutoModerationBuilder<T> setIsEnabled(bool isEnabled) {
    this.isEnabled = isEnabled;
    return this;
  }

  AutoModerationBuilder<T> addAction(AutoModerationAction action) {
    this.actions.add(action);
    return this;
  }

  AutoModerationBuilder<T> addExemptRoles(Snowflake exemptRole) {
    this.exemptRoles.add(exemptRole);
    return this;
  }

  AutoModerationBuilder<T> addExemptChannels(Snowflake exemptChannel) {
    this.exemptChannels.add(exemptChannel);
    return this;
  }

  Map<String, dynamic> build() {
    return {
      'name': name,
      'eventType': eventType?.value,
      'trigger': trigger,
      'isEnabled': isEnabled,
      'actions': actions,
      'exemptRoles': exemptRoles,
      'exemptChannels': exemptChannels,
    };
  }
}
