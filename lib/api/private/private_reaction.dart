import 'package:mineral/api/common/emoji.dart';
import 'package:mineral/api/common/reaction.dart';
import 'package:mineral/api/common/reaction_properties.dart';
import 'package:mineral/api/private/channels/private_channel.dart';
import 'package:mineral/api/private/private_message.dart';
import 'package:mineral/api/private/user.dart';
import 'package:mineral/infrastructure/internals/marshaller/marshaller.dart';

final class PrivateReaction implements Reaction<PrivateMessage> {
  final ReactionProperties _properties;
  final marshaller = Marshaller.singleton();
  final User user;

  PrivateReaction(this._properties, {
    required this.user,
  });

  @override
  bool get burst => _properties.burst;

  @override
  List<String> get burstColors => _properties.burstColors;

  @override
  late final PrivateChannel channel;

  @override
  Emoji get emoji => _properties.emoji;

  @override
  late final PrivateMessage message;
}