import 'package:mineral/api.dart';
import 'package:mineral/src/api/emoji.dart';

class ForumTag {
  final Snowflake _id;
  final String _label;
  final bool _moderated;
  final Snowflake _emojiId;
  final String _emojiLabel;
  final Snowflake _channelId;

  ForumTag(this._id, this._label, this._moderated, this._emojiId, this._emojiLabel, this._channelId);

  Snowflake get id => _id;
  String get label => _label;
  bool get moderated => _moderated;
}
