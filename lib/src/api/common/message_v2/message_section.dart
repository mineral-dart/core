import 'package:mineral/api.dart';
import 'package:mineral/src/api/common/message_v2/message_thumbnail.dart';

final class MessageSection implements MessageComponent {
  ComponentType get type => ComponentType.section;

  final MessageComponentBuilder _builder;
  final MessageButton? _button;
  final MessageThumbnail? _thumbnail;

  MessageSection(
    MessageComponentBuilder builder, {
    MessageButton? button,
    MessageThumbnail? thumbnail,
  })  : _builder = builder,
        _button = button,
        _thumbnail = thumbnail;

  @override
  Map<String, dynamic> toJson() {
    if (_button != null && _thumbnail != null) {
      throw FormatException('Accessory must be either a button or a thumbnail');
    }

    return {
      'type': type.value,
      if (_button != null || _thumbnail != null)
        'accessory': _button?.toJson() ?? _thumbnail?.toJson(),
      'components': _builder.build(),
    };
  }
}
