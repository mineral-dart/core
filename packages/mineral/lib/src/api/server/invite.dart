import 'package:mineral/api.dart';
import 'package:mineral/container.dart';
import 'package:mineral/contracts.dart';

final class Invite {
  DataStoreContract get _datastore => ioc.resolve<DataStoreContract>();

  final InviteType type;
  final String code;

  final Snowflake? serverId;
  final Snowflake? channelId;
  final Snowflake inviterId;

  final Duration maxAge;
  final int maxUses;
  final DateTime createdAt;
  final DateTime? expiresAt;
  final bool isTemporary;

  Invite(
      {required this.type,
      required this.code,
      required this.maxAge,
      required this.maxUses,
      required this.inviterId,
      required this.isTemporary,
      required this.createdAt,
      this.serverId,
      this.channelId,
      this.expiresAt});

  Future<User?> resolveInviter() {
    return _datastore.user.get(inviterId.value, false);
  }

  Future<T?> resolveChannel<T extends Channel>() async {
    if (channelId == null) {
      return null;
    }

    return _datastore.channel.get<T>(channelId!.value, false);
  }

  Future<InviteMetadata?> resolveMetadata({bool force = false}) {
    return _datastore.invite.getExtrasMetadata(code, force);
  }

  Future<void> delete({String? reason}) {
    return _datastore.invite.delete(code, reason);
  }
}

final class InviteMetadata {
  final int approximateMemberCount;
  final int approximatePresenceCount;

  InviteMetadata({
    this.approximateMemberCount = 0,
    this.approximatePresenceCount = 0,
  });
}

enum InviteType {
  server(0),
  privateGroup(1),
  friend(2);

  const InviteType(this.value);
  final int value;

  factory InviteType.of(int value) {
    return values.firstWhere((e) => e.value == value);
  }
}

enum InviteTargetType {
  unknown(-1),
  stream(0),
  embededApplication(1);

  const InviteTargetType(this.value);
  final int value;

  factory InviteTargetType.of(int value) {
    return values.firstWhere((e) => e.value == value);
  }
}
