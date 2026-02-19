import 'package:mineral/api.dart';

final class Thumbnail implements MessageComponent {
  ComponentType get type => ComponentType.thumbnail;
  final MediaItem media;

  Thumbnail(this.media);

  @override
  Map<String, dynamic> toJson() {
    return {
      'type': type.value,
      'media': {
        'url': media.url,
        if (media.proxyUrl != null) 'proxy_url': media.proxyUrl,
        if (media.height != null) 'height': media.height,
        if (media.width != null) 'width': media.width,
        if (media.contentType != null) 'content_type': media.contentType,
      },
      if (media.description != null) 'description': media.description,
      if (media.spoiler != null) 'spoiler': media.spoiler,
    };
  }
}
