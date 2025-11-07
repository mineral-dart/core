import 'package:mineral/api.dart';

final class MessageSection implements Component {
  ComponentType get type => ComponentType.section;

  final MessageBuilder builder;
  final Button? _button;
  final MessageThumbnail? _thumbnail;

  MessageSection({
    required this.builder,
    Button? button,
    MessageThumbnail? thumbnail,
  })  : _button = button,
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
      'components': builder.build(),
    };
  }
}
