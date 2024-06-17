import 'package:mineral/api/common/emoji.dart';
import 'package:mineral/api/common/reaction.dart';
import 'package:mineral/api/common/reaction_properties.dart';
import 'package:mineral/api/server/channels/server_channel.dart';
import 'package:mineral/api/server/member.dart';
import 'package:mineral/api/server/server_message.dart';

final class ServerReaction implements Reaction<ServerMessage> {
  final ReactionProperties _properties;
  final Member member;

  ServerReaction(this._properties, {
    required this.member,
  });

  @override
  bool get burst => _properties.burst;

  @override
  List<String> get burstColors => _properties.burstColors;

  @override
  late final ServerChannel channel;

  @override
  Emoji get emoji => _properties.emoji;

  @override
  late final ServerMessage message;
}