import 'package:mineral/api/common/types/enhanced_enum.dart';

enum DialogElementType implements EnhancedEnum<int> {
  text(1),
  paragraph(2);

  @override
  final int value;

  const DialogElementType(this.value);
}
