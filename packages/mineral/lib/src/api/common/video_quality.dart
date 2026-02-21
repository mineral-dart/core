import 'package:mineral/src/api/common/types/enhanced_enum.dart';

enum VideoQuality implements EnhancedEnum<int> {
  auto(1),
  full(2);

  @override
  final int value;

  const VideoQuality(this.value);
}
