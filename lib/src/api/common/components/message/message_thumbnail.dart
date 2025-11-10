import 'package:mineral/api.dart';

final class MessageThumbnail implements Component {
  ComponentType get type => ComponentType.thumbnail;
  final MediaItem media;

  MessageThumbnail(this.media);

  @override
  Map<String, dynamic> toJson() {
    return {
      'type': type.value,
      ...media.toJson(),
    };
  }
}
