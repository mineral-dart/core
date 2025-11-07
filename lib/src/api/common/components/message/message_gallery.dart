import 'package:mineral/api.dart';
import 'package:mineral/src/api/common/components/asset.dart';

final class MessageGallery implements Component {
  ComponentType get type => ComponentType.mediaGallery;
  final List<Asset> _items;

  MessageGallery({required List<Asset> items}) : _items = items;

  @override
  Map<String, dynamic> toJson() {
    return {
      'type': type.value,
      'items': _items.map((e) => e.toJson()).toList(),
    };
  }
}
