import 'package:mineral/api.dart';

final class Thumbnail implements MessageComponent {
  ComponentType get type => ComponentType.thumbnail;
  final MediaItem media;

  Thumbnail(this.media);

  @override
  Map<String, dynamic> toJson() {
    return {
      'type': type.value,
      ...media.toJson(),
    };
  }
}
