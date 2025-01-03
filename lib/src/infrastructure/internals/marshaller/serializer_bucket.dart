import 'package:mineral/src/api/common/channel.dart';
import 'package:mineral/src/api/common/channel_permission_overwrite.dart';
import 'package:mineral/src/api/common/embed/message_embed.dart';
import 'package:mineral/src/api/common/emoji.dart';
import 'package:mineral/src/api/common/message.dart';
import 'package:mineral/src/api/common/polls/poll.dart';
import 'package:mineral/src/api/common/sticker.dart';
import 'package:mineral/src/api/private/user.dart';
import 'package:mineral/src/api/server/channels/thread_channel.dart';
import 'package:mineral/src/api/server/member.dart';
import 'package:mineral/src/api/server/member_assets.dart';
import 'package:mineral/src/api/server/role.dart';
import 'package:mineral/src/api/server/server.dart';
import 'package:mineral/src/domains/contracts/marshaller/marshaller.dart';
import 'package:mineral/src/infrastructure/internals/marshaller/serializers/channel_permission_overwrite_serializer.dart';
import 'package:mineral/src/infrastructure/internals/marshaller/serializers/channel_serializer.dart';
import 'package:mineral/src/infrastructure/internals/marshaller/serializers/embed_serializer.dart';
import 'package:mineral/src/infrastructure/internals/marshaller/serializers/emoji_serializer.dart';
import 'package:mineral/src/infrastructure/internals/marshaller/serializers/member_serializer.dart';
import 'package:mineral/src/infrastructure/internals/marshaller/serializers/message_serializer.dart';
import 'package:mineral/src/infrastructure/internals/marshaller/serializers/poll_serializer.dart';
import 'package:mineral/src/infrastructure/internals/marshaller/serializers/role_serializer.dart';
import 'package:mineral/src/infrastructure/internals/marshaller/serializers/server_serializer.dart';
import 'package:mineral/src/infrastructure/internals/marshaller/serializers/sticker_serializer.dart';
import 'package:mineral/src/infrastructure/internals/marshaller/serializers/thread_serializer.dart';
import 'package:mineral/src/infrastructure/internals/marshaller/serializers/user_serializer.dart';
import 'package:mineral/src/infrastructure/internals/marshaller/types/serializer.dart';

final class SerializerBucket {
  final SerializerContract<Channel> channels;

  final SerializerContract<Server> server;

  final SerializerContract<Member> member;

  final SerializerContract<User> user;

  final SerializerContract<Role> role;

  final SerializerContract<Emoji> emojis;

  final SerializerContract<Sticker> sticker;

  final SerializerContract<ChannelPermissionOverwrite>
      channelPermissionOverwrite;

  final SerializerContract<Message> message;

  final SerializerContract<MessageEmbed> embed;

  final SerializerContract<Poll> poll;

  final SerializerContract<ThreadChannel> thread;

  SerializerBucket(MarshallerContract marshaller)
      : channels = ChannelSerializer(),
        server = ServerSerializer(),
        member = MemberSerializer(),
        user = UserSerializer(),
        role = RoleSerializer(),
        emojis = EmojiSerializer(),
        sticker = StickerSerializer(),
        channelPermissionOverwrite = ChannelPermissionOverwriteSerializer(),
        message = MessageSerializer(),
        embed = EmbedSerializer(),
        thread = ThreadSerializer(),
        poll = PollSerializer();
}
