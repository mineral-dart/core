import 'package:mineral/api/common/emoji.dart';
import 'package:mineral/api/common/reaction.dart';
import 'package:mineral/api/common/reaction_properties.dart';
import 'package:mineral/api/private/channels/private_channel.dart';
import 'package:mineral/api/private/private_message.dart';
import 'package:mineral/infrastructure/internals/marshaller/marshaller.dart';

final class PrivateReaction implements Reaction<PrivateMessage> {
  final ReactionProperties _properties;
  final marshaller = Marshaller.singleton();

  PrivateReaction(this._properties);

  @override
  bool get burst => _properties.burst;

  @override
  List<String> get burstColors => _properties.burstColors;

  @override
  late final PrivateChannel channel;

  @override
  Emoji get emoji => _properties.emoji;

  @override
  int get count => _properties.count;

  @override
  late final PrivateMessage message;
}