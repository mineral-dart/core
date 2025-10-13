import 'package:mineral/src/api/common/components/component_type.dart';
import 'package:mineral/src/api/common/components/component.dart';
import 'package:mineral/src/api/common/partial_emoji.dart';
import 'package:mineral/src/api/common/snowflake.dart';
import 'package:mineral/src/api/common/types/channel_type.dart';

final class MessageMenu<T> implements Component {
  final ComponentType _type;
  final String _customId;

  String? _placeholder;
  int? _minLength;
  int? _maxLength;
  int? _minValues;
  int? _maxValues;
  bool? _disabled;

  final List<SelectMenuOption<T>> _options;
  final List<Snowflake> _defaultValues;
  final List<ChannelType> _channelTypes;

  MessageMenu(this._type, this._customId,
      {String? placeholder,
      int? minLength,
      int? maxLength,
      int? minValues,
      int? maxValues,
      bool? disabled,
      List<SelectMenuOption<T>>? options,
      List<Snowflake>? defaultValues,
      List<ChannelType>? channelTypes})
      : _placeholder = placeholder,
        _minLength = minLength,
        _maxLength = maxLength,
        _disabled = disabled,
        _options = options ?? [],
        _defaultValues = defaultValues ?? [],
        _channelTypes = channelTypes ?? [];

  static MessageMenu text(
    String customId,
    List<SelectMenuOption<String>> options, {
    String? placeholder,
    int? minLength,
    int? maxLength,
    bool? disabled,
  }) =>
      MessageMenu(ComponentType.textSelectMenu, customId,
          placeholder: placeholder,
          minLength: minLength,
          maxLength: maxLength,
          disabled: disabled,
          options: options);

  static MessageMenu channel(
    String customId, {
    String? placeholder,
    int? minValues,
    int? maxValues,
    bool? disabled,
    List<Snowflake> defaultValues = const [],
    List<ChannelType> channelTypes = const [],
  }) =>
      MessageMenu<String>(ComponentType.channelSelectMenu, customId,
          placeholder: placeholder,
          minValues: minValues,
          maxValues: maxValues,
          disabled: disabled,
          defaultValues: defaultValues,
          channelTypes: channelTypes);

  factory MessageMenu.user(
    String customId, {
    String? placeholder,
    int? minValues,
    int? maxValues,
    bool? disabled,
    List<Snowflake> defaultValues = const [],
  }) =>
      MessageMenu(ComponentType.userSelectMenu, customId,
          placeholder: placeholder,
          minValues: minValues,
          maxValues: maxValues,
          disabled: disabled,
          defaultValues: defaultValues);

  factory MessageMenu.role(
    String customId, {
    String? placeholder,
    int? minValues,
    int? maxValues,
    bool? disabled,
    List<Snowflake> defaultValues = const [],
  }) =>
      MessageMenu(ComponentType.roleSelectMenu, customId,
          placeholder: placeholder,
          minValues: minValues,
          maxValues: maxValues,
          disabled: disabled,
          defaultValues: defaultValues);

  factory MessageMenu.mentionable(
    String customId, {
    String? placeholder,
    int? minValues,
    int? maxValues,
    bool? disabled,
    List<Snowflake> defaultValues = const [],
  }) =>
      MessageMenu(ComponentType.mentionableSelectMenu, customId,
          placeholder: placeholder,
          minValues: minValues,
          maxValues: maxValues,
          disabled: disabled,
          defaultValues: defaultValues);

  @override
  Map<String, dynamic> toJson() {
    return {
      'type': _type.value,
      'custom_id': _customId,
      'placeholder': _placeholder,
      'disabled': _disabled,
      if (_minValues != null) 'min_values': _minValues,
      if (_maxValues != null) 'max_values': _maxValues,
      if (_minLength != null) 'min_length': _minLength,
      if (_maxLength != null) 'max_length': _maxLength,
      if (_options.isNotEmpty)
        'options': _options.map((e) => e.toJson()).toList(),
      if (_channelTypes.isNotEmpty)
        'channel_types': _channelTypes.map((e) => e.value).toList(),
      if (_defaultValues.isNotEmpty)
        'default_values': _defaultValues
            .map((e) => {
                  'id': e.value,
                  'type': switch (_type) {
                    ComponentType.userSelectMenu => 'user',
                    ComponentType.roleSelectMenu => 'role',
                    ComponentType.channelSelectMenu => 'channel',
                    _ => throw Exception('Invalid select menu type'),
                  },
                })
            .toList(),
    };
  }
}

final class SelectMenuOption<T> {
  final String label;
  final String? description;
  final T value;
  final PartialEmoji? emoji;
  final bool? isDefault;

  SelectMenuOption(
      {required this.label,
      required this.value,
      this.description,
      this.emoji,
      this.isDefault = false});

  Map<String, dynamic> toJson() {
    return {
      'label': label,
      'value': value,
      'description': description,
      if (emoji != null)
        'emoji': {
          'name': emoji?.name,
          'id': emoji?.id,
          'animated': emoji?.animated,
        },
      'default': isDefault,
    };
  }
}
