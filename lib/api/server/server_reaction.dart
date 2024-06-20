import 'package:mineral/api/common/emoji.dart';
import 'package:mineral/api/common/reaction.dart';
import 'package:mineral/api/common/reaction_properties.dart';
import 'package:mineral/api/server/channels/server_channel.dart';
import 'package:mineral/api/server/server_message.dart';

final class ServerReaction implements Reaction<ServerMessage> {
  final ReactionProperties _properties;

  ServerReaction(this._properties);

  @override
  bool get burst => _properties.burst;

  @override
  List<String> get burstColors => _properties.burstColors;

  @override
  late final ServerChannel channel;

  @override
  int get count => _properties.count;

  @override
  Emoji get emoji => _properties.emoji;

  @override
  late final ServerMessage message;

  void incrementCount() {
    _properties.count++;
  }

  void decrementCount() {
    _properties.count--;
  }
}