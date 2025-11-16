# 4.1.0-dev.1

## Major Features

- Added a wide range of new Discord events: audit logs, invites, typing, polls, auto-moderation, auto-mod triggers, message reaction remove all.
- Full implementation of Components V2 + Interactive Components V2.
- Added support for modals and introduced a major refactor of message & modal components (breaking change).
- Migrated to the `hmr` package for hot-reload.
- Improved voice system: missing exports, `resolveServer`, and member voice states loaded from cache.
- Enhanced Command Manager + added regex validation for command names.
- Added `createdAt` getters across multiple entities.

## Internal Improvements

- Migrated the EnvironmentService to `env_guard`.
- Reworked attachments handling in interactions.
- Rerun of the ready event to ensure the bot instance always exists.
- Added several missing exports.

## Important Fixes

- Fixed crashes related to audit logs.
- Fixed missing `inline` parameter in embed addField.
- Fixed multiple voice-related issues (null channel ID, missing exports, nullable serverId).
- Fixed IoC binding issues (Bot binding + GlobalStateManager resolution).

# 4.0.0-dev.11

- Add `Message` as return type of `.send` and `.reply` methods

# 4.0.0-dev.10

- Rework member `Role` properties
- Enforce `Snowflake` type parsing
- Change `PermissionOverwrite`
- Add missing `thumbnail` property on `MessageEmbedBuilder`
- Implement `InteractiveDialog`, `InteractiveMenu`, `InteractiveButton`

# 4.0.0-dev.9

- Complete overhaul of the API data structures
- Continued implementation of API classes
- Added rate-limit management
- Implement `audit-log` event
- Implement message reaction events

# 4.0.0-dev.8

- Fix `Member` option in commands
- Fix `Role` option in commands

# 4.0.0-dev.7

- Add missing `LogLevel` enum in exports
- Fix parent channel as ServerChannel

# 4.0.0-dev.6

- Enhance architecture
- Move interfaces to dedicated domain
- Rename mixins
- Change `Dialog` methods builder
- Implement global states
- Migrate services passing in constructors to `ioc` resolver
- Add a reconnection treatment when the heartbeat is missed 3 times
- Implement multiple running strategies

# 4.0.0-dev.5

- Add event parameters
- Prepare integration with `mineral_cli`

# 4.0.0-dev.4

- Add server methods
- Add server events
- Fix missing `server_id` property (see [pull request](https://github.com/mineral-dart/core/pull/201))

# 4.0.0-dev.3

- Move core into src folder
- Add `api` import namespace
- Add `container` import namespace
- Add `events` import namespace
- Add `services` import namespace
- Add `utils` import namespace

# 4.0.0-dev.2

## What's Changed

- feat/enhance serialization by @LeadcodeDev in https://github.com/mineral-dart/core/pull/195
- Feat/implement thread events by @PandaGuerrier in https://github.com/mineral-dart/core/pull/196

## 4.0.0-dev.1

- Fix late initialization error by @PandaGuerrier in https://github.com/mineral-dart/core/pull/101
- feat: Improve some changes by @LeadcodeDev in https://github.com/mineral-dart/core/pull/102
- feat: Upgrade of CLI service and some changes by @LeadcodeDev in https://github.com/mineral-dart/core/pull/103
- add soundboard feature by @PandaGuerrier in https://github.com/mineral-dart/core/pull/104
- Fix: Lot of bug fixes (may refactoring) by @vic256 in https://github.com/mineral-dart/core/pull/105
- docs: Write related guild documentations by @LeadcodeDev in https://github.com/mineral-dart/core/pull/106
- feat: Add permission structure by @LeadcodeDev in https://github.com/mineral-dart/core/pull/108
- Added threads (only by message) by @PandaGuerrier in https://github.com/mineral-dart/core/pull/109
- Added activities in GUILD_CREATE packet. by @PandaGuerrier in https://github.com/mineral-dart/core/pull/107
- feat: References by @PandaGuerrier in https://github.com/mineral-dart/core/pull/110
- Feat/doc by @PandaGuerrier in https://github.com/mineral-dart/core/pull/111
- fix: Accept null guild features by @vic256 in https://github.com/mineral-dart/core/pull/112
- Fix/permissions by @PandaGuerrier in https://github.com/mineral-dart/core/pull/113
- Feat: commands (roles, users and channels) permissions by @PandaGuerrier in https://github.com/mineral-dart/core/pull/115
- Improved the DX for subcommands by @PandaGuerrier in https://github.com/mineral-dart/core/pull/114
- feat: implement discord features & improve commands by @LeadcodeDev in https://github.com/mineral-dart/core/pull/116
- feat: implement missing features by @LeadcodeDev in https://github.com/mineral-dart/core/pull/117
- Before release by @PandaGuerrier in https://github.com/mineral-dart/core/pull/118
- Before release by @PandaGuerrier in https://github.com/mineral-dart/core/pull/119
- Feat: Implement snowflake timestamp by @vic256 in https://github.com/mineral-dart/core/pull/120
- Fix: option can be null by @PandaGuerrier in https://github.com/mineral-dart/core/pull/121
- Added reaction events by @PandaGuerrier in https://github.com/mineral-dart/core/pull/122
- Fix: delete interaction message by @PandaGuerrier in https://github.com/mineral-dart/core/pull/123
- Utils before release by @PandaGuerrier in https://github.com/mineral-dart/core/pull/124
- fix: allow nullables by @LeadcodeDev in https://github.com/mineral-dart/core/pull/125
- Fix/guild create by @PandaGuerrier in https://github.com/mineral-dart/core/pull/126
- New release by @PandaGuerrier in https://github.com/mineral-dart/core/pull/127
- feat: implement error handling by @LeadcodeDev in https://github.com/mineral-dart/core/pull/128
- feat: implement container by @LeadcodeDev in https://github.com/mineral-dart/core/pull/129
- feat: implement http service by @LeadcodeDev in https://github.com/mineral-dart/core/pull/130
- feat: implement environment service by @LeadcodeDev in https://github.com/mineral-dart/core/pull/131
- feat: implement logger service by @LeadcodeDev in https://github.com/mineral-dart/core/pull/132
- feat: implement kernel and developer settings by @LeadcodeDev in https://github.com/mineral-dart/core/pull/133
- feat: implement http endpoint repositories by @LeadcodeDev in https://github.com/mineral-dart/core/pull/134
- feat: implement console by @LeadcodeDev in https://github.com/mineral-dart/core/pull/135
- feat: Implement http rate limit by @abitofevrything in https://github.com/mineral-dart/core/pull/136
- Fix/intents by @LeadcodeDev in https://github.com/mineral-dart/core/pull/138
- feat(events): event managing by @LeadcodeDev in https://github.com/mineral-dart/core/pull/139
- feat(serializers): implement api serializers by @LeadcodeDev in https://github.com/mineral-dart/core/pull/140
- feat/implement-hmr by @LeadcodeDev in https://github.com/mineral-dart/core/pull/141
- feat/enhance infrastructure by @LeadcodeDev in https://github.com/mineral-dart/core/pull/152
- feat/implement-slash-commands-builder by @LeadcodeDev in https://github.com/mineral-dart/core/pull/155
- feat/implement-commands-domain by @PandaGuerrier in https://github.com/mineral-dart/core/pull/157
- feat(ioc): change ioc resolver from string to type by @LeadcodeDev in https://github.com/mineral-dart/core/pull/159
- feat(api): implement stage voice channels by @LeadcodeDev in https://github.com/mineral-dart/core/pull/164
- feat/enhance marshaller data structure by @LeadcodeDev in https://github.com/mineral-dart/core/pull/168
- feat/implement command translations and command definition by @LeadcodeDev in https://github.com/mineral-dart/core/pull/173
- feat/implement command class by @LeadcodeDev in https://github.com/mineral-dart/core/pull/175
- Implement interaction methods by @PandaGuerrier in https://github.com/mineral-dart/core/pull/166
- fix/member not exist when ban by @LeadcodeDev in https://github.com/mineral-dart/core/pull/177
- Implement member methods by @LeadcodeDev in https://github.com/mineral-dart/core/pull/178
- feat/implement-components by @LeadcodeDev in https://github.com/mineral-dart/core/pull/182
- feat/implement components by @LeadcodeDev in https://github.com/mineral-dart/core/pull/189
- Fix/multiple bugs by @PandaGuerrier in https://github.com/mineral-dart/core/pull/190
- remove member from cache when ban by @PyGaVS in https://github.com/mineral-dart/core/pull/180

## New Contributors

- @abitofevrything made their first contribution in https://github.com/mineral-dart/core/pull/136
- @PyGaVS made their first contribution in https://github.com/mineral-dart/core/pull/180

## 3.1.0

- Implement Invites
- Implement invite packets (create, delete)
- Implement many select menus (dynamic, user, role, channel, mentionable)
- Migrate of Discord component to builders (wait next release to allow constructor declaration)
- Improve `main.dart` file entrypoint
- Implement new package concept
- Fix message delete issue (no message when resolving from message id)

## 3.0.0

- Implement cli & refactor
- Implement new features
- Assign true templates
- Improve core
- Add commands git
- Implement Attachments
- Channel not initialized
- Implement http builder & split http service
- Edit attachments in messages
- Implement message bulk delete
- Improve cache
- Interaction and commands in dm channels
- Improve users

## 2.6.2

- Fix bad guild id
- Remove nullable content of `Message`

## 2.6.1

- Remove `late` keyword & refactor
- Improve `ButtonInteration` access with getters

## 2.6.0

- Remove mixins to public access
- Add `createdAt` and `updatedAt` to `Message`
- Add correct message type from `fetch()`

## 2.5.0

- Add `make:service`
- Add `<String>.equals(value)`
- Remove String formatters and implement Recase

## 2.4.1

- Fix wrong template (make:event)
- Fix wrong template (make:state)

## 2.4.0

- Redesign of the order guest
- Implemented the new CLI from `mineral_cli`.
- Removing dependencies using `ffi`
- Refactor application
- Move managers to services

## 2.3.1

- Fix bad User avatar decoration type
- Improve `category.create()` return type
- Make allow and deny to no required params

## 2.3.0

- Improve context menu declaration
- Fix bad state matching

## 2.2.0

- Add plugins access to the `MineralContext`

## 2.1.0

- Migrate environment to dedicated package

## 2.0.0 - Release

- Improve accessibility
- Implement lasted Discord updates
- Move decorators to fully generics
- Improve collections key matching (thanks generics)
- Move framework context to dedicated mixin `MineralContext`
- Move ioc accessibility to dedicated mixin `Container`
- Standardized packages entrypoints
- Add executable compile feature
- More..

## 1.2.1

- Fix wrong userId key into interactions

## 1.2.0

- Implement `setDefaultReactionEmoji` method
- Implement `setTags` method
- Implement `setDefaultRateLimit` method

## 1.1.0

- Implement forum channels

## 1.0.8 - 1.0.9

- Add missing return

## 1.0.7

- Implement `unban` method
- Improve voice member

## 1.0.6

- Fix CategoryChannel cast
- Improve `nickname` getter, it returns the username if nickname is not defined
- Implement `getOrFail` and `getOr` methods on Environment

## 1.0.5

- Fix missing examples

## 1.0.4

- Fix badge url

## 1.0.3

- Improve `dart analyse` to get 100%
- Generate api documentation

## 1.0.2

- Write documentation examples

## 1.0.1

- Improve readme shields
- Improve `dart analyse` to get 100%
- Remove unimplemented code

## 1.0.0 Pre-release

- Initialize mineral framework project
