import 'package:mineral/src/api/common/components/component_type.dart';
import 'package:mineral/src/api/common/components/menus/select_menu_option.dart';
import 'package:mineral/src/api/common/components/message_component.dart';
import 'package:mineral/src/api/common/partial_emoji.dart';
import 'package:mineral/src/api/common/snowflake.dart';
import 'package:mineral/src/api/common/types/channel_type.dart';

abstract interface class SelectMenuBuilderContract
    implements MessageComponent {}

final class SelectMenuBuilder {
  static SelectMenuTextBuilder<String> text(String customId) =>
      SelectMenuTextBuilder(customId);

  static SelectMenuChannelBuilder channel(String customId) =>
      SelectMenuChannelBuilder(customId);

  static SelectMenuUserBuilder user(String customId) =>
      SelectMenuUserBuilder(customId);

  static SelectMenuRoleBuilder role(String customId) =>
      SelectMenuRoleBuilder(customId);

  static SelectMenuMentionableBuilder mentionable(String customId) =>
      SelectMenuMentionableBuilder(customId);
}

final class SelectMenuTextBuilder<T>
    with SelectMenuImpl<SelectMenuTextBuilder>
    implements SelectMenuBuilderContract {
  final String _customId;
  final List<SelectMenuOption<T>> _options = [];

  SelectMenuTextBuilder(this._customId);

  SelectMenuTextBuilder addOption(
      {required String label,
      required T value,
      String? description,
      PartialEmoji? emoji,
      bool isDefault = false}) {
    _options.add(SelectMenuOption(
      label: label,
      value: value,
      description: description,
      emoji: emoji,
      isDefault: isDefault,
    ));
    return this;
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      ...super.toJson(),
      'type': ComponentType.textSelectMenu.value,
      'custom_id': _customId,
      'options': _options.map((e) => e.toJson()).toList(),
    };
  }
}

final class SelectMenuChannelBuilder
    with SelectMenuImpl<SelectMenuChannelBuilder>
    implements SelectMenuBuilderContract {
  final String _customId;

  final List<Snowflake> _defaultChannels = [];
  final List<ChannelType> _channelTypes = [];

  SelectMenuChannelBuilder(this._customId);

  SelectMenuChannelBuilder setDefaultChannels(List<Snowflake> ids) {
    _defaultChannels.addAll(ids);
    return this;
  }

  SelectMenuChannelBuilder setChannelTypes(List<ChannelType> types) {
    _channelTypes.addAll(types);
    return this;
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      ...super.toJson(),
      'type': ComponentType.channelSelectMenu.value,
      'custom_id': _customId,
      'channel_types': _channelTypes.isNotEmpty
          ? _channelTypes.map((e) => e.value).toList()
          : null,
      'default_values': _defaultChannels.isNotEmpty
          ? _defaultChannels
              .map((e) => {'id': e.value, 'type': 'channel'})
              .toList()
          : null,
    };
  }
}

final class SelectMenuUserBuilder
    with SelectMenuImpl<SelectMenuUserBuilder>
    implements SelectMenuBuilderContract {
  final String _customId;

  SelectMenuUserBuilder(this._customId);

  @override
  Map<String, dynamic> toJson() {
    return {
      ...super.toJson(),
      'type': ComponentType.userSelectMenu.value,
      'custom_id': _customId,
    };
  }
}

final class SelectMenuRoleBuilder
    with SelectMenuImpl<SelectMenuRoleBuilder>
    implements SelectMenuBuilderContract {
  final String _customId;

  SelectMenuRoleBuilder(this._customId);

  @override
  Map<String, dynamic> toJson() {
    return {
      ...super.toJson(),
      'type': ComponentType.roleSelectMenu.value,
      'custom_id': _customId,
    };
  }
}

final class SelectMenuMentionableBuilder
    with SelectMenuImpl<SelectMenuMentionableBuilder>
    implements SelectMenuBuilderContract {
  final String _customId;

  SelectMenuMentionableBuilder(this._customId);

  @override
  Map<String, dynamic> toJson() {
    return {
      ...super.toJson(),
      'type': ComponentType.mentionableSelectMenu.value,
      'custom_id': _customId,
    };
  }
}

mixin SelectMenuImpl<T extends SelectMenuBuilderContract> {
  String? _placeholder;
  int? _min;
  int? _max;
  bool? _disabled;

  T setPlaceholder(String placeholder) {
    _placeholder = placeholder;
    return this as T;
  }

  T setConstraint({int? min, int? max, bool? disabled}) {
    _min = min ?? _min;
    _max = max ?? _max;
    _disabled = disabled ?? _disabled;

    return this as T;
  }

  Map<String, dynamic> toJson() {
    return {
      'placeholder': _placeholder,
      'min_values': _min,
      'max_values': _max,
      'disabled': _disabled,
    };
  }
}
