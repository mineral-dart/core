import 'package:mineral/api/common/types/enhanced_enum.dart';

enum PresetType implements EnhancedEnum<int> {
  profanity(1, 'Words that may be considered forms of swearing or cursing'),
  sexualContent(2, 'Words that refer to sexually explicit behavior or activity'),
  slurs(3, 'Personal insults or words that may be considered hate speech');

  @override
  final int value;
  final String description;

  const PresetType(this.value, this.description);
}
