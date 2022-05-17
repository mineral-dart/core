import 'package:mineral/src/api/user.dart';

class GuildMember {
  User user;
  String? nickname;
  String? avatar;
  DateTime joinedAt;
  DateTime? premiumSince;
  bool deaf;
  bool mute;
  bool pending;
  DateTime? timeout;

  GuildMember({
    required this.user,
    required this.nickname,
    required this.avatar,
    required this.joinedAt,
    required this.premiumSince,
    required this.deaf,
    required this.mute,
    required this.pending,
    required this.timeout
  });

  factory GuildMember.from({ required user, dynamic member }) {
    print(member['premium_since']);
    return GuildMember(
      user: user,
      nickname: member['nick'],
      avatar: member['avatar'],
      joinedAt: DateTime.parse(member['joined_at']),
      premiumSince: member['premium_since'] != null ? DateTime.parse(member['premium_since']) : null,
      deaf: member['deaf'] == true,
      mute: member['mute'] == true,
      pending: member['pending'] == true,
      timeout: member['communication_disabled_until'] != null ? DateTime.parse(member['communication_disabled_until']) : null
    );
  }
}
