import 'package:mineral/core/api.dart';
import 'package:mineral/framework.dart';
import 'package:mineral/src/api/managers/channel_manager.dart';
import 'package:mineral/src/api/managers/member_manager.dart';
import 'package:mineral_ioc/ioc.dart';

/// Represents a [GuildScheduledEvent] status of a [User].
enum ScheduledEventStatus {
  /// The event is scheduled.
  scheduled(1),
  /// The event is active.
  active(2),
  /// The event is completed.
  completed(3),
  /// The event is canceled.
  canceled(4);

  final int value;
  const ScheduledEventStatus(this.value);
}

/// Represents a [GuildScheduledEvent] of a [Guild].
enum ScheduledEventEntityType {
  /// The event is a stage instance.
  stageInstance(1),
  /// The event is a voice channel.
  voice(2),
  /// The event is a external stream.
  external(3);

  final int value;
  const ScheduledEventEntityType(this.value);
}

/// Represents a [User] of a [GuildScheduledEvent].
class ScheduledEventUser {
  User user;
  GuildScheduledEvent event;
  GuildMember? member;

  ScheduledEventUser({
    required this.user,
    required this.event,
    required this.member
  });
}

/// Represents a scheduled event of a [Guild].
class GuildScheduledEvent {
  Snowflake _id;
  Snowflake? _guildId;
  GuildChannel? _channel;
  GuildMember? _creator;
  String _name;
  String? _description;
  String _startTime;
  String? _endTime;
  int _status;
  int _entityType;
  Snowflake? _entityId;
  String? _location;
  String? _image;

  GuildScheduledEvent(
    this._id,
    this._guildId,
    this._channel,
    this._creator,
    this._name,
    this._description,
    this._startTime,
    this._endTime,
    this._status,
    this._entityType,
    this._entityId,
    this._image,
    this._location,
  );

  /// Get the id of this.
  Snowflake get id => _id;

  /// Get the [Guild] of this.
  Guild? get guild => ioc.use<MineralClient>().guilds.cache.get(_guildId);

  /// Get the [GuildChannel] of this.
  GuildChannel? get channel => _channel;

  /// Get the [GuildMember] of this.
  GuildMember? get creator => _creator;

  /// Get the name of this.
  String get name => _name;

  /// Get the description of this.
  String? get description => _description;

  /// Get the start time of this.
  DateTime get startTime => DateTime.parse(_startTime);

  /// Get the end time of this.
  DateTime? get endTime => _endTime != null
    ? DateTime.parse(_endTime!)
    : null;

  /// Get the [ScheduledEventStatus] of this.
  ScheduledEventStatus get status => ScheduledEventStatus.values.firstWhere((element) => element.value == _status);

  /// Get the [ScheduledEventEntityType] of this.
  ScheduledEventEntityType get entityType => ScheduledEventEntityType.values.firstWhere((element) => element.value == _entityType);

  /// Get the entity id of this.
  Snowflake? get entityId => _entityId;

  /// Get the location of this.
  String? get location => _location;

  /// Get the image of this.
  String? get image => _image;

  factory GuildScheduledEvent.from({ required ChannelManager channelManager, required MemberManager memberManager, required payload }) {
    return GuildScheduledEvent(
      payload['id'],
      payload['guild_id'],
      payload['channel_id'] != null ? channelManager.cache.get(payload['channel_id']) : null,
      payload['creator_id'] != null ? memberManager.cache.get(payload['creator_id']) : null,
      payload['name'],
      payload['description'],
      payload['scheduled_start_time'],
      payload['scheduled_end_time'],
      payload['status'],
      payload['entity_type'],
      payload['entity_id'],
      payload['image'],
      payload['entity_metadata'] != null && payload['entity_metadata']['location'] != null ? payload['entity_metadata']['location'] : null
    );
  }
}
