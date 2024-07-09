import 'package:mineral/api/common/channel.dart';
import 'package:mineral/api/common/channel_permission_overwrite.dart';
import 'package:mineral/api/common/embed/message_embed.dart';
import 'package:mineral/api/common/emoji.dart';
import 'package:mineral/api/common/message.dart';
import 'package:mineral/api/common/polls/poll.dart';
import 'package:mineral/api/common/sticker.dart';
import 'package:mineral/api/private/user.dart';
import 'package:mineral/api/server/member.dart';
import 'package:mineral/api/server/role.dart';
import 'package:mineral/api/server/server.dart';
import 'package:mineral/api/server/server_assets.dart';
import 'package:mineral/api/server/server_settings.dart';
import 'package:mineral/api/server/server_subscription.dart';
import 'package:mineral/infrastructure/interaction/command/global_command_context.dart';
import 'package:mineral/infrastructure/interaction/command/guild_command_context.dart';
import 'package:mineral/infrastructure/internals/marshaller/marshaller.dart';
import 'package:mineral/infrastructure/internals/marshaller/serializers/channel_permission_overwrite_serializer.dart';
import 'package:mineral/infrastructure/internals/marshaller/serializers/channel_serializer.dart';
import 'package:mineral/infrastructure/internals/marshaller/serializers/embed_serializer.dart';
import 'package:mineral/infrastructure/internals/marshaller/serializers/emoji_serializer.dart';
import 'package:mineral/infrastructure/internals/marshaller/serializers/global_command_context_serializer.dart';
import 'package:mineral/infrastructure/internals/marshaller/serializers/server_command_context_serializer.dart';
import 'package:mineral/infrastructure/internals/marshaller/serializers/member_serializer.dart';
import 'package:mineral/infrastructure/internals/marshaller/serializers/message_serializer.dart';
import 'package:mineral/infrastructure/internals/marshaller/serializers/poll_serializer.dart';
import 'package:mineral/infrastructure/internals/marshaller/serializers/role_serializer.dart';
import 'package:mineral/infrastructure/internals/marshaller/serializers/server_assets_serializer.dart';
import 'package:mineral/infrastructure/internals/marshaller/serializers/server_serializer.dart';
import 'package:mineral/infrastructure/internals/marshaller/serializers/server_settings_serializer.dart';
import 'package:mineral/infrastructure/internals/marshaller/serializers/server_subscription_serializer.dart';
import 'package:mineral/infrastructure/internals/marshaller/serializers/sticker_serializer.dart';
import 'package:mineral/infrastructure/internals/marshaller/serializers/user_serializer.dart';
import 'package:mineral/infrastructure/internals/marshaller/types/serializer.dart';

abstract interface class SerializerBucket {
  SerializerContract<Channel?> get channels;

  SerializerContract<Server> get server;

  SerializerContract<Member> get member;

  SerializerContract<User> get user;

  SerializerContract<Role> get role;

  SerializerContract<ServerSubscription> get serverSubscription;

  SerializerContract<ServerSettings> get serverSettings;

  SerializerContract<ServerAsset> get serversAsset;

  SerializerContract<Emoji> get emojis;

  SerializerContract<Sticker> get sticker;

  SerializerContract<ChannelPermissionOverwrite> get channelPermissionOverwrite;

  SerializerContract<Message> get message;

  SerializerContract<MessageEmbed> get embed;

  SerializerContract<Poll> get poll;

  SerializerContract<GlobalCommandContext> get globalCommandContext;

  SerializerContract<ServerCommandContext> get guildCommandContext;
}

final class SerializerBucketImpl<T> implements SerializerBucket {
  @override
  final SerializerContract<Channel> channels;

  @override
  final SerializerContract<Server> server;

  @override
  final SerializerContract<Member> member;

  @override
  final SerializerContract<User> user;

  @override
  final SerializerContract<Role> role;

  @override
  final SerializerContract<ServerSubscription> serverSubscription;

  @override
  final SerializerContract<ServerSettings> serverSettings;

  @override
  final SerializerContract<ServerAsset> serversAsset;

  @override
  final SerializerContract<Emoji> emojis;

  @override
  final SerializerContract<Sticker> sticker;

  @override
  final SerializerContract<ChannelPermissionOverwrite> channelPermissionOverwrite;

  @override
  final SerializerContract<Message> message;

  @override
  final SerializerContract<MessageEmbed> embed;

  @override
  final SerializerContract<Poll> poll;

  @override
  final SerializerContract<GlobalCommandContext> globalCommandContext;

  @override
  final SerializerContract<ServerCommandContext> guildCommandContext;

  SerializerBucketImpl(MarshallerContract marshaller)
      : channels = ChannelSerializer(marshaller),
        server = ServerSerializer(marshaller),
        member = MemberSerializer(marshaller),
        user = UserSerializer(marshaller),
        role = RoleSerializer(marshaller),
        serverSubscription = ServerSubscriptionSerializer(marshaller),
        serverSettings = ServerSettingsSerializer(marshaller),
        serversAsset = ServerAssetsSerializer(marshaller),
        emojis = EmojiSerializer(marshaller),
        sticker = StickerSerializer(marshaller),
        channelPermissionOverwrite = ChannelPermissionOverwriteSerializer(marshaller),
        message = MessageSerializer(marshaller),
        embed = EmbedSerializer(marshaller),
        globalCommandContext = GlobalCommandContextSerializer(marshaller),
        guildCommandContext = ServerCommandContextSerializer(marshaller),
        poll = PollSerializer(marshaller);
}
