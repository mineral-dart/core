import 'package:mineral/api.dart';

final class MessageGallery implements Component {
  ComponentType get type => ComponentType.mediaGallery;
  final List<MediaItem> _items;

  MessageGallery({required List<MediaItem> items}) : _items = items;

  @override
  Map<String, dynamic> toJson() {
    return {
      'type': type.value,
      'items': _items.map((e) => e.toJson()).toList(),
    };
  }
}
