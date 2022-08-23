import 'package:mineral/api.dart';
import 'package:mineral/core.dart';
import 'package:mineral/src/api/sticker.dart';

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

  Snowflake get id => _id;
  String get label => _label;
  String? get description => _description;
  String? get icon => '${Constants.cdnUrl}/icons/$id/$_icon.png';
  String? get splash => '${Constants.cdnUrl}/splashes/$id/$_splash.png';
  String? get discoverySplash => '${Constants.cdnUrl}/discovery-splashes/$id/$_discoverySplash.png';
  Map<Snowflake, Emoji> get emojis => _emojis;
  Map<Snowflake, Sticker> get stickers => _stickers;
  List<GuildFeature> get features => _features;
  int get approximateMemberCount => _approximateMemberCount;
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
