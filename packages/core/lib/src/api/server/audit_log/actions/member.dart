import 'package:mineral/api.dart';
import 'package:mineral/container.dart';
import 'package:mineral/contracts.dart';
import 'package:mineral/src/api/server/audit_log/audit_log.dart';

final class MemberKickAuditLog extends AuditLog {
  DataStoreContract get _datastore => ioc.resolve<DataStoreContract>();

  final Snowflake? memberId;
  final String? reason;

  MemberKickAuditLog({
    required Snowflake serverId,
    required Snowflake? userId,
    required this.memberId,
    this.reason,
  }) : super(AuditLogType.memberKick, serverId, userId);

  Future<Member?> resolveMember({bool force = false}) async {
    if (memberId == null) {
      return null;
    }

    final member =
        await _datastore.member.get(serverId.value, memberId!.value, force);
    return member;
  }
}

final class MemberPruneAuditLog extends AuditLog {
  final int deleteMemberDays;
  final int membersRemoved;

  MemberPruneAuditLog({
    required Snowflake serverId,
    required Snowflake? userId,
    required this.deleteMemberDays,
    required this.membersRemoved,
  }) : super(AuditLogType.memberPrune, serverId, userId);
}

final class MemberBanAddAuditLog extends AuditLog {
  DataStoreContract get _datastore => ioc.resolve<DataStoreContract>();

  final Snowflake? memberId;
  final String? reason;

  MemberBanAddAuditLog({
    required Snowflake serverId,
    required Snowflake? userId,
    required this.memberId,
    this.reason,
  }) : super(AuditLogType.memberBanAdd, serverId, userId);

  Future<Member?> resolveMember({bool force = false}) async {
    if (memberId == null) {
      return null;
    }
    final member =
        await _datastore.member.get(serverId.value, memberId!.value, force);
    return member;
  }
}

final class MemberBanRemoveAuditLog extends AuditLog {
  DataStoreContract get _datastore => ioc.resolve<DataStoreContract>();

  final Snowflake? memberId;

  MemberBanRemoveAuditLog({
    required Snowflake serverId,
    required Snowflake? userId,
    required this.memberId,
  }) : super(AuditLogType.memberBanRemove, serverId, userId);

  Future<Member?> resolveMember({bool force = false}) async {
    if (memberId == null) {
      return null;
    }

    final member =
        await _datastore.member.get(serverId.value, memberId!.value, force);
    return member;
  }
}

final class MemberUpdateAuditLog extends AuditLog {
  DataStoreContract get _datastore => ioc.resolve<DataStoreContract>();

  final Snowflake? memberId;
  final List<Change> changes;

  MemberUpdateAuditLog({
    required Snowflake serverId,
    required Snowflake? userId,
    required this.memberId,
    required this.changes,
  }) : super(AuditLogType.memberUpdate, serverId, userId);

  Future<Member?> resolveMember({bool force = false}) async {
    if (memberId == null) {
      return null;
    }

    final member =
        await _datastore.member.get(serverId.value, memberId!.value, force);
    return member;
  }
}

final class MemberRoleUpdateAuditLog extends AuditLog {
  DataStoreContract get _datastore => ioc.resolve<DataStoreContract>();

  final Snowflake? memberId;
  final List<Change> changes;

  MemberRoleUpdateAuditLog({
    required Snowflake serverId,
    required Snowflake? userId,
    required this.memberId,
    required this.changes,
  }) : super(AuditLogType.memberRoleUpdate, serverId, userId);

  Future<Member?> resolveMember({bool force = false}) async {
    if (memberId == null) {
      return null;
    }

    final member =
        await _datastore.member.get(serverId.value, memberId!.value, force);
    return member;
  }
}

final class MemberMoveAuditLog extends AuditLog {
  DataStoreContract get _datastore => ioc.resolve<DataStoreContract>();

  final Snowflake? memberId;
  final Snowflake? channelId;

  MemberMoveAuditLog({
    required Snowflake serverId,
    required Snowflake? userId,
    required this.memberId,
    this.channelId,
  }) : super(AuditLogType.memberMove, serverId, userId);

  Future<Member?> resolveMember({bool force = false}) async {
    if (memberId == null) {
      return null;
    }

    final member =
        await _datastore.member.get(serverId.value, memberId!.value, force);
    return member;
  }

  Future<Channel?> resolveChannel({bool force = false}) async {
    if (channelId == null) {
      return null;
    }

    final channel = await _datastore.channel.get(channelId!.value, force);
    return channel;
  }
}

final class MemberDisconnectAuditLog extends AuditLog {
  DataStoreContract get _datastore => ioc.resolve<DataStoreContract>();

  final Snowflake? memberId;

  MemberDisconnectAuditLog({
    required Snowflake serverId,
    required Snowflake? userId,
    required this.memberId,
  }) : super(AuditLogType.memberDisconnect, serverId, userId);

  Future<Member?> resolveMember({bool force = false}) async {
    if (memberId == null) {
      return null;
    }

    final member =
        await _datastore.member.get(serverId.value, memberId!.value, force);
    return member;
  }
}

final class BotAddAuditLog extends AuditLog {
  DataStoreContract get _datastore => ioc.resolve<DataStoreContract>();

  final Snowflake? botId;

  BotAddAuditLog({
    required Snowflake serverId,
    required Snowflake? userId,
    required this.botId,
  }) : super(AuditLogType.botAdd, serverId, userId);

  Future<Member?> resolveBot({bool force = false}) async {
    if (botId == null) {
      return null;
    }

    final member =
        await _datastore.member.get(serverId.value, botId!.value, force);
    return member;
  }
}
