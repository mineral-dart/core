import 'package:mineral/api.dart';

final class MessageThumbnail implements Component {
  ComponentType get type => ComponentType.thumbnail;
  final MediaItem asset;

  MessageThumbnail(this.asset);

  @override
  Map<String, dynamic> toJson() {
    return {
      'type': type.value,
      ...asset.toJson(),
    };
  }
}
