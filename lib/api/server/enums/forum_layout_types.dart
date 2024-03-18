import 'package:mineral/api/common/types/enhanced_enum.dart';

enum ForumLayoutType implements EnhancedEnum<int> {
  notSet(0),
  listView(1),
  galleryView(2);

  final int value;
  const ForumLayoutType(this.value);
}
