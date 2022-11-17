import 'package:mineral/core/api.dart';

class ScreenField {
  Snowflake channelId;
  String description;
  Snowflake emojiId;
  String emojiName;

  ScreenField({
    required this.channelId,
    required this.description,
    required this.emojiId,
    required this.emojiName
  });

  factory ScreenField.from(dynamic payload) {
    return ScreenField(
      channelId: payload['channel_id'],
      description: payload['description'],
      emojiId: payload['emoji_id'],
      emojiName: payload['emoji_name'],
    );
  }
}

class WelcomeScreen {
  String description;
  List<ScreenField> fields;

  WelcomeScreen({ required this.description, required this.fields });

  factory WelcomeScreen.from(dynamic payload) {
    List<ScreenField> fields = [];
    for (dynamic element in payload['welcome_channels']) {
      ScreenField field = ScreenField.from(element);
      fields.add(field);
    }

    return WelcomeScreen(
        description: payload['description'],
        fields: fields
    );
  }
}
