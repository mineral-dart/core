import 'package:mineral/api.dart';

final class MessageGallery implements MessageComponent {
  ComponentType get type => ComponentType.mediaGallery;

  final List<GalleryItem> _items;

  MessageGallery({required List<GalleryItem> items}) : _items = items;

  @override
  Map<String, dynamic> toJson() {
    return {
      'type': type.value,
      'items': _items.map((e) => e.toJson()).toList(),
    };
  }
}

final class GalleryItem {
  final MessageMedia _media;
  final String? _description;
  final bool? _spoiler;

  GalleryItem(
    String url, {
    String? proxyUrl,
    int? height,
    int? width,
    String? contentType,
    String? description,
    bool? spoiler,
  })  : _media = MessageMedia(
          url,
          proxyUrl: proxyUrl,
          height: height,
          width: width,
          contentType: contentType,
        ),
        _description = description,
        _spoiler = spoiler;

  Map<String, dynamic> toJson() {
    return {
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
