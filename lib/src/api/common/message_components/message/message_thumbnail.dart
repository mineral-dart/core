import 'package:mineral/api.dart';

final class MessageThumbnail implements Component {
  ComponentType get type => ComponentType.thumbnail;

  final MessageMedia _media;
  final String? _description;
  final bool? _spoiler;

  MessageThumbnail(
    MessageMedia media, {
    String? description,
    bool? spoiler,
  })  : _media = media,
        _description = description,
        _spoiler = spoiler;

  @override
  Map<String, dynamic> toJson() {
    return {
      'type': type.value,
      'media': {
        'url': _media.url,
        if (_media.proxyUrl != null) 'proxy_url': _media.proxyUrl,
        if (_media.height != null) 'height': _media.height,
        if (_media.width != null) 'width': _media.width,
        if (_media.contentType != null) 'content_type': _media.contentType,
      },
      if (_description != null) 'description': _description,
      if (_spoiler != null) 'spoiler': _spoiler,
    };
  }
}
