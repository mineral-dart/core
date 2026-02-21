# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Mineral is a Discord bot framework for Dart (v4.3.0). It provides a type-safe, builder-pattern API for creating Discord bots with commands, events, interactive components, and state management.

This repository is a **Dart Pub Workspace** monorepo containing 3 packages:

- **`mineral`** (`packages/mineral/`) — Core framework, published on pub.dev
- **`mineral_cache`** (`packages/mineral_cache/`) — Cache provider implementations
- **`mineral_cli`** (`packages/mineral_cli/`) — CLI tools for scaffolding and managing bot projects

## Commands

```bash
# Workspace-wide (run from repo root)
dart pub get                                          # Install all workspace dependencies
dart analyze                                          # Analyze all packages

# Per-package
cd packages/mineral && dart test                      # Run core tests
cd packages/mineral_cache && dart test                # Run cache tests
cd packages/mineral_cli && dart test                  # Run CLI tests
cd packages/mineral && dart test test/internals/ioc.dart  # Run a single test file
cd packages/mineral && dart run example/main.dart     # Run the example bot
```

## Architecture

### Workspace Structure

```
/                               (workspace root)
├── pubspec.yaml                (workspace orchestrator, not publishable)
├── analysis_options.yaml       (shared linting config)
└── packages/
    ├── mineral/                (core framework)
    ├── mineral_cache/          (cache providers)
    └── mineral_cli/            (CLI tools)
```

### Mineral Core — Layered Structure (Clean Architecture / DDD)

All paths below are relative to `packages/mineral/`.

**API Layer** (`lib/src/api/`) — Pure Discord data models, split into:

- `common/` — Shared types: channels, messages, embeds, commands, components, permissions, snowflakes
- `private/` — DM-specific: PrivateChannel, User
- `server/` — Guild-specific: Server, Member, Role, channels, managers (ChannelManager, MemberManager, etc.)

**Domain Layer** (`lib/src/domains/`) — Business logic:

- `client/` — `Client` and `ClientBuilder` (main entry point, fluent builder API)
- `commands/` — Command declaration, routing, and interaction dispatch
- `events/` — Event system with `EventBucket`, `EventListener`, `EventDispatcher`; 50+ typed events (server, private, common)
- `components/` — Interactive UI: buttons, modals, select menus with context-aware handlers
- `global_states/` — Application-wide state management via `GlobalState<T>`
- `providers/` — Service provider lifecycle (`ready()`/`dispose()`)
- `common/` — Kernel (orchestrator), IoC container, HMR support

**Infrastructure Layer** (`lib/src/infrastructure/`) — Implementation details:

- `internals/` — WebSocket orchestration/sharding, marshalling (ETF/JSON), packet dispatch, environment config
- `services/` — HTTP client with interceptors, logger, datastore (REST wrapper)

### Public API Exports

Barrel files at `packages/mineral/lib/` level: `api.dart` (main exports, 130+), `container.dart`, `contracts.dart`, `events.dart`, `services.dart`, `utils.dart`.

### Key Patterns

- **IoC Container**: Global singleton `ioc` with `bind<T>()`, `make<T>()`, `resolve<T>()`, `override<T>()`, `restore<T>()`
- **Builder Pattern**: `ClientBuilder`, `MessageBuilder`, `CommandBuilder`, `ModalBuilder`, etc.
- **Fluent API**: Chainable setters using cascade (`..setName()..setDescription()..setHandle()`)
- **Client.register()**: Polymorphic registration — accepts commands, events, states, providers, or components via type-switch
- **Encoding Strategy**: Supports both JSON and ETF (Erlang Term Format) for WebSocket communication
- **HMR**: Hot Module Replacement for development via `setHmrDevPort(port)` and file watchers

### Entry Point Flow

`ClientBuilder.build()` → validates env → creates HTTP client → configures sharding → initializes Kernel → binds services to IoC → returns `Client` → `client.init()` starts the bot.

## Code Style

- Dart SDK ^3.6.0
- Linting: `package:lints/recommended.yaml` with strict additions (see `analysis_options.yaml`)
- Prefer single quotes, `final` locals, cascade invocations, return type annotations
- `avoid_void_async`, `type_annotate_public_apis`, `always_declare_return_types`
- No line length limit (`lines_longer_than_80_chars: false`)

## Publishing

Tag convention for publishing to pub.dev:

- `mineral-v4.3.0` → publishes `packages/mineral/`
- `mineral_cache-v0.1.0` → publishes `packages/mineral_cache/`
- `mineral_cli-v0.1.0` → publishes `packages/mineral_cli/`
