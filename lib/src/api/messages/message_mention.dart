import 'package:mineral/core/api.dart';
import 'package:mineral/framework.dart';

class MessageMention {
  final GuildChannel _channel;
  final List<Snowflake> _channels;
  final List<Snowflake> _members;
  final List<Snowflake> _roles;
  final bool _everyone;

  MessageMention(this._channel, this._channels, this._members, this._roles, this._everyone);

  Map<Snowflake, GuildMember> get members {
    Map<Snowflake, GuildMember> members = {};
    for (final element in _members) {
      final GuildMember member = _channel.guild.members.cache.getOrFail(element);
      members.putIfAbsent(member.id, () => member);
    }

    return members;
  }

  Map<Snowflake, Role> get roles {
    Map<Snowflake, Role> roles = {};
    for (final element in _roles) {
      final Role role = _channel.guild.roles.cache.getOrFail(element);
      roles.putIfAbsent(role.id, () => role);
    }

    return roles;
  }

  Map<Snowflake, GuildChannel> get channels {
    Map<Snowflake, GuildChannel> channels = {};
    for (final element in _channels) {
      final GuildChannel channel = _channel.guild.channels.cache.getOrFail(element);
      channels.putIfAbsent(channel.id, () => channel);
    }

    return channels;
  }

  bool get isEveryone => _everyone;
}
