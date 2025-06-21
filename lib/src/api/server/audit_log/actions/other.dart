import 'package:mineral/api.dart';
import 'package:mineral/src/api/server/audit_log/audit_log.dart';

final class CreatorMonetizationRequestCreatedAuditLog extends AuditLog {
  final String requestId;

  CreatorMonetizationRequestCreatedAuditLog({
    required Snowflake serverId,
    required Snowflake userId,
    required this.requestId,
  }) : super(AuditLogType.creatorMonetizationRequestCreated, serverId, userId);
}

final class CreatorMonetizationTermsAcceptedAuditLog extends AuditLog {
  final String termsId;

  CreatorMonetizationTermsAcceptedAuditLog({
    required Snowflake serverId,
    required Snowflake userId,
    required this.termsId,
  }) : super(AuditLogType.creatorMonetizationTermsAccepted, serverId, userId);
}

final class OnboardingPromptCreateAuditLog extends AuditLog {
  final Snowflake promptId;
  final String promptTitle;

  OnboardingPromptCreateAuditLog({
    required Snowflake serverId,
    required Snowflake userId,
    required this.promptId,
    required this.promptTitle,
  }) : super(AuditLogType.onboardingPromptCreate, serverId, userId);
}

final class OnboardingPromptUpdateAuditLog extends AuditLog {
  final Snowflake promptId;
  final List<Change> changes;

  OnboardingPromptUpdateAuditLog({
    required Snowflake serverId,
    required Snowflake userId,
    required this.promptId,
    required this.changes,
  }) : super(AuditLogType.onboardingPromptUpdate, serverId, userId);
}

final class OnboardingPromptDeleteAuditLog extends AuditLog {
  final Snowflake promptId;
  final String promptTitle;

  OnboardingPromptDeleteAuditLog({
    required Snowflake serverId,
    required Snowflake userId,
    required this.promptId,
    required this.promptTitle,
  }) : super(AuditLogType.onboardingPromptDelete, serverId, userId);
}

final class OnboardingCreateAuditLog extends AuditLog {
  final List<Change> changes;

  OnboardingCreateAuditLog({
    required Snowflake serverId,
    required Snowflake userId,
    required this.changes,
  }) : super(AuditLogType.onboardingCreate, serverId, userId);
}

final class OnboardingUpdateAuditLog extends AuditLog {
  final List<Change> changes;

  OnboardingUpdateAuditLog({
    required Snowflake serverId,
    required Snowflake userId,
    required this.changes,
  }) : super(AuditLogType.onboardingUpdate, serverId, userId);
}

final class HomeSettingsCreateAuditLog extends AuditLog {
  final List<Change> changes;

  HomeSettingsCreateAuditLog({
    required Snowflake serverId,
    required Snowflake userId,
    required this.changes,
  }) : super(AuditLogType.homeSettingsCreate, serverId, userId);
}

final class HomeSettingsUpdateAuditLog extends AuditLog {
  final List<Change> changes;

  HomeSettingsUpdateAuditLog({
    required Snowflake serverId,
    required Snowflake userId,
    required this.changes,
  }) : super(AuditLogType.homeSettingsUpdate, serverId, userId);
}
