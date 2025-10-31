import 'package:mineral/api.dart';
import 'package:mineral/src/api/server/audit_log/actions/other.dart';
import 'package:mineral/src/api/server/audit_log/audit_log.dart';

Future<AuditLog> creatorMonetizationRequestCreatedAuditLogHandler(
  Map<String, dynamic> json,
) async {
  return CreatorMonetizationRequestCreatedAuditLog(
    serverId: Snowflake.parse(json['guild_id']),
    userId: Snowflake.parse(json['user_id']),
    requestId: json['target_id'],
  );
}

Future<AuditLog> creatorMonetizationTermsAcceptedAuditLogHandler(
  Map<String, dynamic> json,
) async {
  return CreatorMonetizationTermsAcceptedAuditLog(
    serverId: Snowflake.parse(json['guild_id']),
    userId: Snowflake.parse(json['user_id']),
    termsId: json['target_id'],
  );
}

Future<AuditLog> onboardingPromptCreateAuditLogHandler(
  Map<String, dynamic> json,
) async {
  return OnboardingPromptCreateAuditLog(
    serverId: Snowflake.parse(json['guild_id']),
    userId: Snowflake.parse(json['user_id']),
    promptId: Snowflake.parse(json['target_id']),
    promptTitle: json['changes'][0]['new_value'],
  );
}

Future<AuditLog> onboardingPromptUpdateAuditLogHandler(
  Map<String, dynamic> json,
) async {
  return OnboardingPromptUpdateAuditLog(
    serverId: Snowflake.parse(json['guild_id']),
    userId: Snowflake.parse(json['user_id']),
    promptId: Snowflake.parse(json['target_id']),
    changes: List<Map<String, dynamic>>.from(json['changes'])
        .map(Change.fromJson)
        .toList(),
  );
}

Future<AuditLog> onboardingPromptDeleteAuditLogHandler(
  Map<String, dynamic> json,
) async {
  return OnboardingPromptDeleteAuditLog(
    serverId: Snowflake.parse(json['guild_id']),
    userId: Snowflake.parse(json['user_id']),
    promptId: Snowflake.parse(json['target_id']),
    promptTitle: json['changes'][0]['old_value'],
  );
}

Future<AuditLog> onboardingCreateAuditLogHandler(
  Map<String, dynamic> json,
) async {
  return OnboardingCreateAuditLog(
    serverId: Snowflake.parse(json['guild_id']),
    userId: Snowflake.parse(json['user_id']),
    changes: List<Map<String, dynamic>>.from(json['changes'])
        .map(Change.fromJson)
        .toList(),
  );
}

Future<AuditLog> onboardingUpdateAuditLogHandler(
  Map<String, dynamic> json,
) async {
  return OnboardingUpdateAuditLog(
    serverId: Snowflake.parse(json['guild_id']),
    userId: Snowflake.parse(json['user_id']),
    changes: List<Map<String, dynamic>>.from(json['changes'])
        .map(Change.fromJson)
        .toList(),
  );
}

Future<AuditLog> homeSettingsCreateAuditLogHandler(
  Map<String, dynamic> json,
) async {
  return HomeSettingsCreateAuditLog(
    serverId: Snowflake.parse(json['guild_id']),
    userId: Snowflake.parse(json['user_id']),
    changes: List<Map<String, dynamic>>.from(json['changes'])
        .map(Change.fromJson)
        .toList(),
  );
}

Future<AuditLog> homeSettingsUpdateAuditLogHandler(
  Map<String, dynamic> json,
) async {
  return HomeSettingsUpdateAuditLog(
    serverId: Snowflake.parse(json['guild_id']),
    userId: Snowflake.parse(json['user_id']),
    changes: List<Map<String, dynamic>>.from(json['changes'])
        .map(Change.fromJson)
        .toList(),
  );
}
