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
      'event_type': eventType?.value,
      'trigger_type': trigger?.type.value,
      'trigger_metadata': trigger?.toJson(),
      'enabled': isEnabled,
      'actions': actions.map((action) => action.toJson()).toList(),
      'exempt_roles':
          exemptRoles.isNotEmpty ? exemptRoles.map((role) => role.value).toList() : null,
      'exempt_channels': exemptChannels.isNotEmpty
          ? exemptChannels.map((channel) => channel.value).toList()
          : null,
    };
  }
}
