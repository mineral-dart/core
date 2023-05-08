import 'package:mineral/core/api.dart';
import 'package:mineral/src/api/builders/component_wrapper.dart';
import 'package:mineral/src/api/builders/menus/select_menu_builder.dart';

/// A builder for select menus component.
class ChannelSelectMenuBuilder extends SelectMenuBuilder {
  final List<ChannelType> _channels = [];

  ChannelSelectMenuBuilder(String customId) : super (customId, ComponentType.channelSelect);

  /// The list of [ChannelType] that can be selected.
  List<ChannelType> get channels => _channels;

  /// Sets the list of [ChannelType] that can be selected.
  void setChannelTypes (List<ChannelType> types) {
    channels.addAll(types);
  }

  /// Serialize this component to a JSON object.
  @override
  Map<String, dynamic> toJson () => {
    ...super.toJson(),
    'channel_types': channels.map((element) => element.value).toList(),
  };
}