import 'package:mineral/core.dart';
import 'package:mineral/core/api.dart';
import 'package:mineral/framework.dart';
import 'package:mineral/src/api/sticker.dart';

/// Represents a preview of a [Guild].
class GuildPreview {
  final Snowflake _id;
  final String _label;
  final String? _description;
  final String? _icon;
  final String? _splash;
  final String? _discoverySplash;
  final Map<Snowflake, Emoji> _emojis;
  final Map<Snowflake, Sticker> _stickers;
  final List<GuildFeature> _features;
  final int _approximateMemberCount;
  final int _approximatePresenceCount;

  GuildPreview(
    this._id,
    this._label,
    this._description,
    this._icon,
    this._splash,
    this._discoverySplash,
    this._emojis,
    this._stickers,
    this._features,
    this._approximateMemberCount,
    this._approximatePresenceCount,
  );

  /// Get the [Guild] id.
  Snowflake get id => _id;

  /// Get the [Guild] label.
  String get label => _label;

  /// Get the [Guild] description.
  String? get description => _description;

  /// Get the [Guild] icon.
  String? get icon => '${Constants.cdnUrl}/icons/$id/$_icon.png';

  /// Get the [Guild] splash.
  String? get splash => '${Constants.cdnUrl}/splashes/$id/$_splash.png';

  /// Get the [Guild] discovery splash.
  String? get discoverySplash => '${Constants.cdnUrl}/discovery-splashes/$id/$_discoverySplash.png';

  /// Get the [Guild] emojis.
  Map<Snowflake, Emoji> get emojis => _emojis;

  /// Get the [Guild] stickers.
  Map<Snowflake, Sticker> get stickers => _stickers;

  /// Get the [Guild] features.
  List<GuildFeature> get features => _features;

  /// Get the [Guild] approximate member count.
  int get approximateMemberCount => _approximateMemberCount;

  /// Get the [Guild] approximate presence count.
  int get approximatePresenceCount => _approximatePresenceCount;

  factory GuildPreview.from({ required Guild guild, required dynamic payload }) {
    final Map<Snowflake, Emoji> emojis = {};
    for (final payload in payload['emojis']) {
      emojis.putIfAbsent(payload['id'], () => guild.emojis.cache.getOrFail(payload['id']));
    }

    final Map<Snowflake, Sticker> stickers = {};
    for (final payload in payload['stickers']) {
      stickers.putIfAbsent(payload['id'], () => guild.stickers.cache.getOrFail(payload['id']));
    }

    final List<GuildFeature> features = [];
    for (final payload in payload['features']) {
      final feature = GuildFeature.values.firstWhere((feature) => feature.value == payload);
      features.add(feature);
    }

    return GuildPreview(
      payload['id'],
      payload['name'],
      payload['description'],
      payload['icon'],
      payload['splash'],
      payload['discovery_splash'],
      emojis,
      stickers,
      features,
      payload['approximate_member_count'],
      payload['approximate_presence_count']
    );
  }
}
