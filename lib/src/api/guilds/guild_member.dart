import 'package:http/http.dart';
import 'package:mineral/api.dart';
import 'package:mineral/core.dart';
import 'package:mineral/src/api/managers/guild_role_manager.dart';
import 'package:mineral/src/api/managers/voice_manager.dart';

class GuildMember {
  User user;
  String? nickname;
  String? avatar;
  DateTime joinedAt;
  DateTime? premiumSince;
  String? permissions;
  bool pending;
  DateTime? timeoutDuration;
  MemberRoleManager roles;
  late VoiceManager voice;
  late Guild guild;

  GuildMember({
    required this.user,
    required this.nickname,
    required this.avatar,
    required this.joinedAt,
    required this.premiumSince,
    required this.permissions,
    required this.pending,
    required this.timeoutDuration,
    required this.roles,
    required this.voice,
  });

  /// ### Update the username of this
  ///
  /// Example :
  /// ```dart
  /// await member.setUsername('John Doe');
  /// ```
  Future<void> setUsername (String name) async {
    Http http = ioc.singleton(ioc.services.http);

    Response response = await http.patch(url: "/guilds/${guild.id}/members/${user.id}", payload: { 'nick': name });
    if (response.statusCode == 200) {
      nickname = name;
    }
  }

  /// ### Excludes this for a pre-defined period
  ///
  /// Note: An exclusion cannot exceed 28 days
  ///
  /// See [documentation](https://discord.com/developers/docs/resources/guild#modify-guild-member)
  ///
  /// Example :
  /// ```dart
  /// final DateTime = DateTime.now().add(Duration(days: 28));
  /// await member.timeout(DateTime);
  /// ```
  Future<void> timeout (DateTime expiration) async {
    // @Todo add ADMINISTRATOR permission or is the owner of the guild constraint
    Http http = ioc.singleton(ioc.services.http);

    Response response = await http.patch(url: '/guilds/${guild.id}/members/${user.id}', payload: { 'communication_disabled_until': expiration.toIso8601String() });
    if (response.statusCode == 200 || response.statusCode == 204) {
      timeoutDuration = expiration;
    }
  }

  /// ### Cancels the exclusion of this
  ///
  /// Example :
  /// ```dart
  /// await member.removeTimeout();
  /// ```
  Future<void> removeTimeout () async {
    Http http = ioc.singleton(ioc.services.http);

    Response response = await http.patch(url: '/guilds/${guild.id}/members/${user.id}', payload: { 'communication_disabled_until': null });
    if (response.statusCode == 200 || response.statusCode == 204) {
      timeoutDuration = null;
    }
  }

  /// ### banned this from the [Guild] and deleted its messages for a given period
  ///
  /// Example :
  /// ```dart
  /// await member.ban();
  /// ```
  /// With the deletion of his messages for 7 days
  ///
  /// Example :
  /// ```dart
  /// await member.ban(count: 7);
  /// ```
  Future<void> ban ({ int? count, String? reason }) async {
    Http http = ioc.singleton(ioc.services.http);

    Response response = await http.put(url: "/guilds/${guild.id}/bans/${user.id}", payload: {
      'delete_message_days': count,
      'reason': reason
    });

    if (response.statusCode == 200) {
      timeoutDuration = null;
    }
  }

  /// ### Kick this of [Guild]
  ///
  /// Example :
  /// ```dart
  /// await member.removeTimeout();
  /// ```
  Future<void> kick ({ int? count, String? reason }) async {
    Http http = ioc.singleton(ioc.services.http);
    await http.destroy(url: "/guilds/${guild.id}/members/${user.id}");
  }

  /// ### Returns whether of this is a bot
  ///
  /// Example :
  /// ```dart
  /// print(member.isBot());
  /// ```
  bool isBot () => user.bot;

  /// ### Returns whether of this is pending
  ///
  /// Example :
  /// ```dart
  /// print(member.isPending());
  /// ```
  bool isPending () => pending;

  @override
  String toString () {
    return "<@${nickname != null ? '!' : ''}${user.id}>";
  }

  clone () {
    return GuildMember(
      user: user,
      nickname: nickname,
      avatar: avatar,
      joinedAt: joinedAt,
      premiumSince: premiumSince,
      permissions: permissions,
      pending: pending,
      timeoutDuration: timeoutDuration,
      roles: roles,
      voice: voice
    )
      ..guild = guild
      ..roles = roles;
  }

  factory GuildMember.from({ required user, required GuildRoleManager roles, dynamic member, required Snowflake guildId, required VoiceManager voice }) {
    MemberRoleManager memberRoleManager = MemberRoleManager(manager: roles, memberId: user.id);
    for (var element in (member['roles'] as List<dynamic>)) {
      Role? role = roles.cache.get(element);
      if (role != null) {
        memberRoleManager.cache.putIfAbsent(role.id, () => role);
      }
    }

    return GuildMember(
      user: user,
      nickname: member['nick'],
      avatar: member['avatar'],
      joinedAt: DateTime.parse(member['joined_at']),
      premiumSince: member['premium_since'] != null ? DateTime.parse(member['premium_since']) : null,
      permissions: member['permissions'],
      pending: member['pending'] == true,
      timeoutDuration: member['communication_disabled_until'] != null ? DateTime.parse(member['communication_disabled_until']) : null,
      roles: memberRoleManager,
      voice: voice,
    );
  }
}
