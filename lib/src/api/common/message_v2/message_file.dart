import 'package:mineral/api.dart';

final class MessageFile implements MessageComponent {
  ComponentType get type => ComponentType.file;

  final String _path;
  final bool? _spoiler;

  MessageFile(this._path, {bool? spoiler}) : _spoiler = spoiler;

  @override
  Map<String, dynamic> toJson() {
    return {
      'type': type.value,
      'file': 'attachment://$_path',
      if (_spoiler != null) 'spoiler': _spoiler,
    };
  }
}
