import 'package:mineral/src/infrastructure/internals/marshaller/cache_key.dart';
import 'package:test/test.dart';

void main() {
  group('CacheKey', () {
    late CacheKey cacheKey;

    setUp(() {
      cacheKey = CacheKey();
    });

    group('server', () {
      test('generates server key', () {
        expect(cacheKey.server('123'), 'server/123');
      });

      test('works with numeric id', () {
        expect(cacheKey.server(456), 'server/456');
      });
    });

    group('serverAssets', () {
      test('generates server assets key', () {
        expect(cacheKey.serverAssets('123'), 'server/123/assets');
      });

      test('generates ref key when ref is true', () {
        expect(
            cacheKey.serverAssets('123', ref: true), 'ref:server/123/assets');
      });

      test('generates non-ref key by default', () {
        expect(cacheKey.serverAssets('123').startsWith('ref:'), isFalse);
      });
    });

    group('serverSettings', () {
      test('generates server settings key', () {
        expect(cacheKey.serverSettings('123'), 'server/123/settings');
      });

      test('generates ref key when ref is true', () {
        expect(cacheKey.serverSettings('123', ref: true),
            'ref:server/123/settings');
      });
    });

    group('serverRules', () {
      test('generates server rules key', () {
        expect(cacheKey.serverRules('123', '456'), 'server/123/rules/456');
      });

      test('generates ref key when ref is true', () {
        expect(cacheKey.serverRules('123', '456', ref: true),
            'ref:server/123/rules/456');
      });
    });

    group('serverSubscription', () {
      test('generates server subscription key', () {
        expect(cacheKey.serverSubscription('123'), 'server/123/subscriptions');
      });

      test('generates ref key when ref is true', () {
        expect(cacheKey.serverSubscription('123', ref: true),
            'ref:server/123/subscriptions');
      });
    });

    group('channel', () {
      test('generates channel key', () {
        expect(cacheKey.channel('789'), 'channels/789');
      });

      test('works with numeric id', () {
        expect(cacheKey.channel(789), 'channels/789');
      });
    });

    group('channelPermission', () {
      test('generates channel permission key', () {
        expect(cacheKey.channelPermission('789'), 'channels/789/permissions');
      });

      test('works with serverId parameter', () {
        expect(cacheKey.channelPermission('789', serverId: '123'),
            'channels/789/permissions');
      });
    });

    group('serverRole', () {
      test('generates server role key', () {
        expect(cacheKey.serverRole('123', '456'), 'server/123/roles/456');
      });
    });

    group('member', () {
      test('generates member key', () {
        expect(cacheKey.member('123', '456'), 'server/123/members/456');
      });

      test('generates ref key when ref is true', () {
        expect(cacheKey.member('123', '456', ref: true),
            'ref:server/123/members/456');
      });
    });

    group('memberAssets', () {
      test('generates member assets key', () {
        expect(cacheKey.memberAssets('123', '456'),
            'server/123/members/456/assets');
      });

      test('generates ref key when ref is true', () {
        expect(cacheKey.memberAssets('123', '456', ref: true),
            'ref:server/123/members/456/assets');
      });
    });

    group('user', () {
      test('generates user key', () {
        expect(cacheKey.user('789'), 'users/789');
      });

      test('generates ref key when ref is true', () {
        expect(cacheKey.user('789', ref: true), 'ref:users/789');
      });
    });

    group('voiceState', () {
      test('generates voice state key', () {
        expect(cacheKey.voiceState('123', '456'),
            'voice_states/server/123/members/456');
      });
    });

    group('invite', () {
      test('generates invite key', () {
        expect(cacheKey.invite('abc123'), 'invites/abc123');
      });
    });

    group('userAssets', () {
      test('generates user assets key', () {
        expect(cacheKey.userAssets('789'), 'users/789/assets');
      });

      test('generates ref key when ref is true', () {
        expect(cacheKey.userAssets('789', ref: true), 'ref:users/789/assets');
      });
    });

    group('serverEmoji', () {
      test('generates server emoji key', () {
        expect(cacheKey.serverEmoji('123', '456'), 'server/123/emojis/456');
      });
    });

    group('message', () {
      test('generates message key', () {
        expect(cacheKey.message('789', '101'), 'channels/789/messages/101');
      });
    });

    group('embed', () {
      test('generates embed key with fixed uid', () {
        expect(
            cacheKey.embed('101', uid: 'fixed'), 'messages/101/embeds/fixed');
      });

      test('generates embed key with auto-generated uuid', () {
        final key = cacheKey.embed('101');
        expect(key, startsWith('messages/101/embeds/'));
        expect(key.length, greaterThan('messages/101/embeds/'.length));
      });

      test('generates unique keys without uid', () {
        final key1 = cacheKey.embed('101');
        final key2 = cacheKey.embed('101');
        expect(key1, isNot(equals(key2)));
      });
    });

    group('poll', () {
      test('generates poll key with fixed uid', () {
        expect(cacheKey.poll('101', uid: 'fixed'), 'messages/101/polls/fixed');
      });

      test('generates poll key with auto-generated uuid', () {
        final key = cacheKey.poll('101');
        expect(key, startsWith('messages/101/polls/'));
        expect(key.length, greaterThan('messages/101/polls/'.length));
      });

      test('generates unique keys without uid', () {
        final key1 = cacheKey.poll('101');
        final key2 = cacheKey.poll('101');
        expect(key1, isNot(equals(key2)));
      });
    });

    group('sticker', () {
      test('generates sticker key', () {
        expect(cacheKey.sticker('123', '456'), 'server/123/stickers/456');
      });
    });

    group('thread', () {
      test('generates thread key', () {
        expect(cacheKey.thread('789'), 'threads/789');
      });
    });

    group('ref pattern consistency', () {
      test('all ref keys start with ref:', () {
        final refKeys = [
          cacheKey.serverAssets('1', ref: true),
          cacheKey.serverSettings('1', ref: true),
          cacheKey.serverRules('1', '2', ref: true),
          cacheKey.serverSubscription('1', ref: true),
          cacheKey.member('1', '2', ref: true),
          cacheKey.memberAssets('1', '2', ref: true),
          cacheKey.user('1', ref: true),
          cacheKey.userAssets('1', ref: true),
        ];

        for (final key in refKeys) {
          expect(key, startsWith('ref:'),
              reason: '$key should start with ref:');
        }
      });

      test('non-ref keys do not start with ref:', () {
        final nonRefKeys = [
          cacheKey.serverAssets('1'),
          cacheKey.serverSettings('1'),
          cacheKey.serverRules('1', '2'),
          cacheKey.serverSubscription('1'),
          cacheKey.member('1', '2'),
          cacheKey.memberAssets('1', '2'),
          cacheKey.user('1'),
          cacheKey.userAssets('1'),
        ];

        for (final key in nonRefKeys) {
          expect(key.startsWith('ref:'), isFalse,
              reason: '$key should not start with ref:');
        }
      });
    });

    group('hierarchical nesting', () {
      test('member key contains server key', () {
        final memberKey = cacheKey.member('123', '456');
        expect(memberKey, contains(cacheKey.server('123')));
      });

      test('memberAssets key contains member key', () {
        final assetsKey = cacheKey.memberAssets('123', '456');
        expect(assetsKey, contains(cacheKey.member('123', '456')));
      });

      test('message key contains channel key', () {
        final messageKey = cacheKey.message('789', '101');
        expect(messageKey, contains(cacheKey.channel('789')));
      });

      test('serverRole key contains server key', () {
        final roleKey = cacheKey.serverRole('123', '456');
        expect(roleKey, contains(cacheKey.server('123')));
      });

      test('serverEmoji key contains server key', () {
        final emojiKey = cacheKey.serverEmoji('123', '456');
        expect(emojiKey, contains(cacheKey.server('123')));
      });

      test('sticker key contains server key', () {
        final stickerKey = cacheKey.sticker('123', '456');
        expect(stickerKey, contains(cacheKey.server('123')));
      });

      test('userAssets key contains user key', () {
        final assetsKey = cacheKey.userAssets('789');
        expect(assetsKey, contains(cacheKey.user('789')));
      });
    });
  });
}
