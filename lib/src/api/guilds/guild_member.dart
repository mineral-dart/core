import 'package:http/http.dart';
import 'package:mineral/api.dart';
import 'package:mineral/core.dart';
import 'package:mineral/src/api/managers/guild_role_manager.dart';

class GuildMember {
  User _user;
  String? _nickname;
  String? _avatar;
  DateTime _joinedAt;
  DateTime? _premiumSince;
  String? _permissions;
  bool _pending;
  DateTime? _timeoutDuration;
  MemberRoleManager _roles;
  VoiceManager voice;
  Guild _guild;

  GuildMember(
    this._user,
    this._nickname,
    this._avatar,
    this._joinedAt,
    this._premiumSince,
    this._permissions,
    this._pending,
    this._timeoutDuration,
    this._roles,
    this.voice,
    this._guild,
  );

  Snowflake get id => _user.id;
  User get user => _user;
  String? get nickname => _nickname;
  String? get avatar => _avatar;
  DateTime get joinedAt => _joinedAt;
  DateTime? get premiumSince => _premiumSince;
  String? get permissions => _permissions;
  bool get pending => _pending;
  DateTime? get timeoutDuration => _timeoutDuration;
  MemberRoleManager get roles => _roles;
  Guild get guild => _guild;

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
      _nickname = name;
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
      _timeoutDuration = expiration;
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
      _timeoutDuration = null;
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
      _timeoutDuration = null;
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

  GuildMember clone () => GuildMember(user, nickname, avatar, joinedAt, premiumSince, permissions, pending, timeoutDuration, roles, voice, guild);

  factory GuildMember.from({ required user, required GuildRoleManager roles, required Guild guild, dynamic member, required VoiceManager voice }) {
    MemberRoleManager memberRoleManager = MemberRoleManager(manager: roles, memberId: user.id);
    for (var element in (member['roles'] as List<dynamic>)) {
      Role? role = roles.cache.get(element);
      if (role != null) {
        memberRoleManager.cache.putIfAbsent(role.id, () => role);
      }
    }

    return GuildMember(
      user,
      member['nick'],
      member['avatar'],
      DateTime.parse(member['joined_at']),
      member['premium_since'] != null ? DateTime.parse(member['premium_since']) : null,
      member['permissions'],
      member['pending'] == true,
      member['communication_disabled_until'] != null ? DateTime.parse(member['communication_disabled_until']) : null,
      memberRoleManager,
      voice,
      guild
    );
  }
}
