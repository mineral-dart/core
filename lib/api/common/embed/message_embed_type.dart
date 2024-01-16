import 'package:mineral/api/common/types/enhanced_enum.dart';

enum MessageEmbedType implements EnhancedEnum<String> {
  rich('rich'),
  image('image'),
  video('video'),
  gifv('gifv'),
  article('article'),
  link('link');

  @override
  final String value;

  const MessageEmbedType(this.value);
}
