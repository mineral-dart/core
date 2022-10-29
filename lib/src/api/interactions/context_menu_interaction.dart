import 'package:mineral/api.dart';

class ContextMenuInteraction extends Interaction {
  final int _type;

  ContextMenuInteraction(
    this._type,
    super._id,
    super._label,
    super._applicationId,
    super._version,
    super._typeId,
    super._token,
    super._userId,
    super._guildId,
  );

  ContextMenuType get typeMenu => ContextMenuType.values.firstWhere((element) => element.value == _type);

  Object get toJson => {
    'name': label,
    'type': _type
  };
}