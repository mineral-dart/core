import 'package:http/http.dart';
import 'package:mineral/core.dart';
import 'package:mineral/core/api.dart';
import 'package:mineral/framework.dart';
import 'package:mineral/src/api/guilds/guild_member_presence.dart';
import 'package:mineral/src/api/managers/guild_role_manager.dart';
import 'package:mineral_ioc/ioc.dart';

/// Represents a member of a [Guild] context.
class GuildMember  {
  User _user;
  String? _nickname;
  String? _avatar;
  DateTime _joinedAt;
  String? _premiumSince;
  String? _permissions;
  bool _pending;
  String? _timeoutDuration;
  MemberRoleManager _roles;
  VoiceManager voice;
  Guild _guild;
  GuildMemberPresence? presence;

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
    this.presence,
  );

  /// Get the guild id.
  Snowflake get id => _user.id;

  /// Get the user of an [Guild] context.
  User get user => _user;

  /// Get the username of an [Guild] context.
  String get nickname => _nickname ?? _user.username;

  /// Get the avatar of an [Guild] context.
  ImageFormater? get avatar => _avatar != null
      ? ImageFormater(_avatar, 'guilds/${guild.id}/users/${user.id}/avatars')
      : null;

  /// Get the [DateTime] of this joined at.
  DateTime get joinedAt => _joinedAt;

  /// Get the [DateTime] of this premium since.
  DateTime? get premiumSince => _premiumSince != null
    ? DateTime.parse(_premiumSince!)
    : null;

  /// Get the permissions of this.
  String? get permissions => _permissions;

  /// Get the pending status of this.
  bool get pending => _pending;

  /// Get the [DateTime] timeout duration of this.
  DateTime? get timeoutDuration => _timeoutDuration != null
    ? DateTime.parse(_timeoutDuration!)
    : null;

  /// Get the roles manager of this.
  MemberRoleManager get roles => _roles;

  /// Get the [Guild] of this.
  Guild get guild => _guild;

  /// This has an avatar.
  bool get hasGuildAvatar => avatar != null;

  /// Get the [Locale] of this.
  Locale get lang => _user.lang;

  /// Returns whether of this is a bot
  bool get isBot => user.isBot;

  /// Returns whether of this is pending
  bool isPending () => pending;

  /// Update the username of this
  ///
  /// ```dart
  /// await member.setUsername('John Doe');
  /// ```
  Future<void> setUsername (String name) async {
    Response response = await ioc.use<DiscordApiHttpService>().patch(url: "/guilds/${guild.id}/members/${user.id}")
      .payload({ 'nick': name })
      .build();

    if (response.statusCode == 200) {
      _nickname = name;
    }
  }

  /// Excludes this for a pre-defined period.
  ///
  /// Note: An exclusion cannot exceed 28 days.
  ///
  /// See [documentation](https://discord.com/developers/docs/resources/guild#modify-guild-member)
  ///
  /// ```dart
  /// final DateTime = DateTime.now().add(Duration(days: 28));
  /// await member.timeout(DateTime);
  /// ```
  Future<void> timeout (DateTime expiration) async {
    Response response = await ioc.use<DiscordApiHttpService>().patch(url: '/guilds/${guild.id}/members/${user.id}')
      .payload({ 'communication_disabled_until': expiration.toIso8601String() })
      .build();

    if (response.statusCode == 200 || response.statusCode == 204) {
      _timeoutDuration = expiration.toIso8601String();
    }
  }

  /// Cancels the exclusion of this
  ///
  /// ```dart
  /// await member.removeTimeout();
  /// ```
  Future<void> removeTimeout () async {
    Response response = await ioc.use<DiscordApiHttpService>().patch(url: '/guilds/${guild.id}/members/${user.id}')
      .payload({ 'communication_disabled_until': null })
      .build();

    if (response.statusCode == 200 || response.statusCode == 204) {
      _timeoutDuration = null;
    }
  }

  /// banned this from the [Guild] and deleted its messages for a given period
  ///
  /// ```dart
  /// await member.ban();
  /// ```
  /// With the deletion of his messages for 7 days
  ///
  /// ```dart
  /// await member.ban(count: 7);
  /// ```
  Future<void> ban ({ int? count, String? reason }) async {
    Response response = await ioc.use<DiscordApiHttpService>().put(url: "/guilds/${guild.id}/bans/${user.id}")
      .payload({ 'delete_message_days': count, 'reason': reason })
      .build();

    if (response.statusCode == 200) {
      _timeoutDuration = null;
    }
  }

  /// Kick this of [Guild]
  ///
  /// ```dart
  /// await member.removeTimeout();
  /// ```
  Future<void> kick ({ int? count, String? reason }) async {
    await ioc.use<DiscordApiHttpService>()
      .destroy(url: "/guilds/${guild.id}/members/${user.id}")
      .build();
  }

  /// Returns a taggable [String] representation of this.
  @override
  String toString () => '<@${_nickname != null ? '!' : ''}${user.id}>';

  /// Returns a clone of this
  GuildMember clone () => GuildMember(user, nickname, _avatar, joinedAt, _premiumSince, permissions, pending, _timeoutDuration, roles, voice, guild, presence);

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
      member['premium_since'],
      member['permissions'],
      member['pending'] == true,
      member['communication_disabled_until'],
      memberRoleManager,
      voice,
      guild,
      null,
    );
  }
}
