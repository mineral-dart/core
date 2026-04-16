import 'package:mineral/api.dart';
import 'package:mineral/container.dart';
import 'package:mineral/contracts.dart';
import 'package:mineral/src/api/common/channel.dart';
import 'package:mineral/src/api/private/channels/private_channel.dart';
import 'package:mineral/src/api/server/channels/server_channel.dart';
import 'package:mineral/src/domains/events/event.dart';
import 'package:mineral/src/infrastructure/internals/marshaller/types/serializer.dart';
import 'package:mineral/src/infrastructure/internals/packets/listenable_packet.dart';
import 'package:mineral/src/infrastructure/internals/packets/listeners/channel_create_packet.dart';
import 'package:mineral/src/infrastructure/internals/wss/shard_message.dart';
import 'package:mineral/src/domains/services/wss/constants/op_code.dart';
import 'package:mineral/src/api/server/managers/threads_manager.dart';
import 'package:test/test.dart';

import '../helpers/fake_logger.dart';

// -- Fakes ------------------------------------------------------------------

/// Minimal [ServerChannel] subclass for type matching in tests.
final class _FakeServerChannel extends ServerChannel {
  @override
  final ChannelProperties properties;

  @override
  ChannelMethods get methods => throw UnimplementedError();

  _FakeServerChannel(this.properties);
}

/// A channel serializer that returns a pre-configured [Channel] on serialize.
final class _FakeChannelSerializer implements SerializerContract<Channel> {
  Channel channelToReturn;

  _FakeChannelSerializer(this.channelToReturn);

  @override
  Map<String, dynamic> normalize(Map<String, dynamic> json) => json;

  @override
  Channel serialize(Map<String, dynamic> json) => channelToReturn;

  @override
  Map<String, dynamic> deserialize(Channel object) =>
      throw UnimplementedError();
}

/// Proxy that mimics [SerializerBucket] via [noSuchMethod].
///
/// [SerializerBucket] is a final class and cannot be extended or implemented
/// outside its library. We use [noSuchMethod] forwarding so that property
/// access like `.channels` returns our fake serializer.
class _SerializerBucketProxy {
  final SerializerContract<Channel> channels;

  _SerializerBucketProxy(this.channels);

  @override
  dynamic noSuchMethod(Invocation invocation) => throw UnimplementedError();
}

/// Stub [MarshallerContract] that provides a fake serializer bucket.
///
/// Because [SerializerBucket] is final, [serializers] returns our proxy
/// cast dynamically. The packet only accesses [serializers.channels], so the
/// proxy is sufficient.
final class _FakeMarshaller implements MarshallerContract {
  final _SerializerBucketProxy _bucket;

  _FakeMarshaller(SerializerContract<Channel> channelSerializer)
      : _bucket = _SerializerBucketProxy(channelSerializer);

  @override
  dynamic get serializers => _bucket;

  @override
  LoggerContract get logger => throw UnimplementedError();

  @override
  dynamic noSuchMethod(Invocation invocation) => throw UnimplementedError();
}

/// Stub [DataStoreContract] so that [PrivateChannel] can be instantiated
/// (its [MessageManager] field resolves this from IoC at construction time).
final class _FakeDataStore implements DataStoreContract {
  @override
  dynamic noSuchMethod(Invocation invocation) => throw UnimplementedError();
}

// -- Helpers ----------------------------------------------------------------

ChannelProperties _minimalProperties({
  Snowflake? serverId,
  ChannelType type = ChannelType.guildText,
}) {
  return ChannelProperties(
    id: Snowflake('1234567890'),
    type: type,
    name: 'test-channel',
    description: null,
    serverId: serverId,
    categoryId: null,
    position: 0,
    nsfw: false,
    lastMessageId: null,
    bitrate: null,
    userLimit: null,
    rateLimitPerUser: null,
    recipients: [],
    icon: null,
    ownerId: null,
    applicationId: null,
    lastPinTimestamp: null,
    rtcRegion: null,
    videoQualityMode: null,
    messageCount: null,
    memberCount: null,
    defaultAutoArchiveDuration: null,
    permissions: null,
    flags: null,
    totalMessageSent: null,
    available: null,
    appliedTags: [],
    defaultReactions: null,
    defaultSortOrder: null,
    defaultForumLayout: null,
    threads: ThreadsManager(null, null),
  );
}

ShardMessage _emptyShardMessage() {
  return ShardMessage(
    type: 'CHANNEL_CREATE',
    opCode: OpCode.dispatch,
    sequence: 1,
    payload: <String, dynamic>{},
  );
}

// -- Tests ------------------------------------------------------------------

void main() {
  group('ChannelCreatePacket', () {
    late ChannelCreatePacket packet;
    late FakeLogger logger;
    late _FakeChannelSerializer channelSerializer;
    late void Function() restoreIoc;

    setUp(() {
      packet = ChannelCreatePacket();
      logger = FakeLogger();

      // Default channel serializer -- overridden per test.
      channelSerializer = _FakeChannelSerializer(
        UnknownChannel(id: Snowflake('0'), name: 'placeholder'),
      );

      final marshaller = _FakeMarshaller(channelSerializer);

      final scope = IocContainer()
        ..bind<LoggerContract>(() => logger)
        ..bind<MarshallerContract>(() => marshaller)
        ..bind<DataStoreContract>(_FakeDataStore.new);
      restoreIoc = scopedIoc(scope);
    });

    tearDown(() {
      restoreIoc();
    });

    test('dispatches Event.serverChannelCreate for a ServerChannel', () async {
      final serverChannel = _FakeServerChannel(
        _minimalProperties(serverId: Snowflake('9999')),
      );
      channelSerializer.channelToReturn = serverChannel;

      Event? capturedEvent;
      List<dynamic>? capturedParams;

      await packet.listen(
        _emptyShardMessage(),
        (
            {required Event event,
            required List params,
            bool Function(String?)? constraint}) {
          capturedEvent = event;
          capturedParams = params;
        },
      );

      expect(capturedEvent, equals(Event.serverChannelCreate));
      expect(capturedParams, hasLength(1));
      expect(capturedParams!.first, same(serverChannel));
    });

    test('dispatches Event.privateChannelCreate for a PrivateChannel',
        () async {
      final privateChannel = PrivateChannel(
        _minimalProperties(type: ChannelType.dm),
      );
      channelSerializer.channelToReturn = privateChannel;

      Event? capturedEvent;
      List<dynamic>? capturedParams;

      await packet.listen(
        _emptyShardMessage(),
        (
            {required Event event,
            required List params,
            bool Function(String?)? constraint}) {
          capturedEvent = event;
          capturedParams = params;
        },
      );

      expect(capturedEvent, equals(Event.privateChannelCreate));
      expect(capturedParams, hasLength(1));
      expect(capturedParams!.first, same(privateChannel));
    });

    test('logs a warning for an unknown channel type', () async {
      final unknownChannel = UnknownChannel(
        id: Snowflake('0'),
        name: 'mystery',
      );
      channelSerializer.channelToReturn = unknownChannel;

      Event? capturedEvent;

      await packet.listen(
        _emptyShardMessage(),
        (
            {required Event event,
            required List params,
            bool Function(String?)? constraint}) {
          capturedEvent = event;
        },
      );

      expect(capturedEvent, isNull,
          reason: 'No event should be dispatched for an unknown channel type');
      expect(logger.warnings, hasLength(1));
      expect(logger.warnings.first, contains('Unknown channel type'));
    });
  });
}
