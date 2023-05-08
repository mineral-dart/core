import 'package:mineral/core/api.dart';
import 'package:mineral_ioc/ioc.dart';

class Footer {
  String text;
  String? iconUrl;
  String? proxyIconUrl;

  Footer({ required this.text, this.iconUrl, this.proxyIconUrl });

  Object toJson () => {
    'text': text,
    'icon_url': iconUrl,
    'proxy_icon_url': proxyIconUrl,
  };
}

class Image {
  String url;
  String? proxyUrl;
  int? width;
  int? height;

  Image({ required this.url, this.proxyUrl, this.width, this.height });

  Object toJson () => {
    'url': url,
    'proxy_url': proxyUrl,
    'width': width,
    'height': height,
  };
}

class Thumbnail {
  String url;
  String? proxyUrl;
  int? height;
  int? width;

  Thumbnail({ required this.url, this.proxyUrl, this.height, this.width });

  Object toJson () => {
    'url': url,
    'proxy_url': proxyUrl,
    'width': width,
    'height': height,
  };
}

class Author {
  String name;
  String? url;
  String? iconUrl;
  String? proxyIconUrl;

  Author({ required this.name, this.url, this.iconUrl, this.proxyIconUrl });

  Object toJson () => {
    'name': name,
    'url': url,
    'icon_url': iconUrl,
    'proxy_icon_url': proxyIconUrl,
  };
}

class Field {
  String name;
  String value;
  bool? inline;

  Field({ required this.name, required this.value, this.inline });

  Object toJson () => {
    'name': name,
    'value': value,
    'inline': inline ?? false,
  };
}

class EmbedBuilder {
  String? title;
  String? description;
  String? url;
  DateTime? timestamp;
  Footer? footer;
  Image? image;
  Thumbnail? thumbnail;
  Author? author;
  List<Field>? fields;
  Color? color;

  EmbedBuilder({
    this.title,
    this.description,
    this.url,
    this.timestamp,
    this.footer,
    this.image,
    this.thumbnail,
    this.author,
    this.fields,
    this.color,
  });

  /// ### Set the [title] field and return this
  ///
  /// Example :
  /// ```dart
  /// final embed = EmbedBuilder()
  ///   .setTitle('My title');
  /// ```
  EmbedBuilder setTitle (String value) {
    title = value;
    return this;
  }

  /// ### Set the [description] field and return this
  ///
  /// Example :
  /// ```dart
  /// final embed = EmbedBuilder()
  ///   .setDescription('My description');
  /// ```
  EmbedBuilder setDescription (String value) {
    description = value;
    return this;
  }

  /// ### Set the [footer] field and return this
  ///
  /// Example :
  /// ```dart
  /// final embed = EmbedBuilder()
  ///   .setFooter(text: 'My title');
  /// ```
  EmbedBuilder setFooter ({ required String text, String? iconUrl, String? proxyIconUrl }) {
    footer = Footer(text: text, iconUrl: iconUrl, proxyIconUrl: proxyIconUrl);
    return this;
  }

  /// ### Set the [image] field and return this
  ///
  /// Example :
  /// ```dart
  /// final embed = EmbedBuilder()
  ///   .setImage(url: 'https://..../images/my_picture.png');
  /// ```
  EmbedBuilder setImage ({ required String url, String? proxyUrl, int? width, int? height }) {
    image = Image(url: url, proxyUrl: proxyUrl, width: width, height: height);
    return this;
  }

  /// ### Set the [thumbnail] field and return this
  ///
  /// Example :
  /// ```dart
  /// final embed = EmbedBuilder()
  ///   .setThumbnail(url: 'https://..../images/my_picture.png');
  /// ```
  EmbedBuilder setThumbnail ({ required String url, String? proxyUrl, int? width, int? height }) {
    thumbnail = Thumbnail(url: url, proxyUrl: proxyUrl, width: width, height: height);
    return this;
  }

  /// ### Set the [author] field and return this
  ///
  /// Example :
  /// ```dart
  /// final embed = EmbedBuilder()
  ///   .setAuthor(name: 'John Doe');
  /// ```
  EmbedBuilder setAuthor ({ required String name, String? url, String? iconUrl, String? proxyIconUrl }) {
    author = Author(name: name, url: url, iconUrl: iconUrl, proxyIconUrl: proxyIconUrl);
    return this;
  }

  /// ### Set the [color] field and return this
  ///
  /// Example :
  /// ```dart
  /// final embed = EmbedBuilder()
  ///   .setColor(Color.cyan_600);
  /// ```
  /// Or with your custom color
  ///
  /// Example :
  /// ```dart
  /// final embed = EmbedBuilder()
  ///   .setColor(Color('#FFFFFF'));
  /// ```
  EmbedBuilder setColor (Color color) {
    this.color = color;
    return this;
  }

  /// ### Set the [timestamp] field and return this
  ///
  /// Example :
  /// ```dart
  /// final embed = EmbedBuilder()
  ///   .setTimestamp();
  /// ```
  /// You can define an older or future timestamp
  /// DateTime date = DateTime.now().add(DateTime(days: 5));
  /// final embed = EmbedBuilder()
  ///   .setTimestamp(dateTime: date);
  /// ```
  EmbedBuilder setTimestamp ({ DateTime? dateTime }) {
    timestamp = dateTime ?? DateTime.now();
    return this;
  }

  /// ### Set the [url] field and return this
  ///
  /// Example :
  /// ```dart
  /// final embed = EmbedBuilder()
  ///   .setUrl('https://.....com');
  /// ```
  EmbedBuilder setUrl (String url) {
    this.url = url;
    return this;
  }

  /// ### Add an field into [fields] and return this
  ///
  /// Example :
  /// ```dart
  /// final embed = EmbedBuilder()
  ///   .addField(name: 'My field', value: 'My custom value');
  /// ```
  EmbedBuilder addField ({ required String name, required String value, bool? inline }) {
    fields ??= [];

    fields?.add(Field(name: name, value: value, inline: inline));
    return this;
  }

  Object toJson () {
    List<dynamic> fields = [];

    if (this.fields != null) {
      for (Field field in this.fields!) {
        fields.add(field.toJson());
      }
    }

    return {
      'title': title,
      'description': description,
      'url': url,
      'footer': footer?.toJson(),
      'timestamp': timestamp?.toIso8601String(),
      'fields': fields,
      'color': color != null ? int.parse(color.toString().replaceAll('#', ''), radix: 16) : null,
      'image': image?.toJson(),
      'thumbnail': thumbnail?.toJson(),
      'author': author?.toJson(),
    };
  }

  factory EmbedBuilder.fromGuildPreview(GuildPreview preview) {
    MineralClient client = ioc.use<MineralClient>();

    final EmbedBuilder embed = EmbedBuilder(
      title: preview.label,
      description: preview.description,
      thumbnail: preview.icon != null ? Thumbnail(url: preview.icon!) : null,
      image: preview.discoverySplash != null ? Image(url: preview.discoverySplash!) : null,
      color: Color.invisible,
      timestamp: DateTime.now(),
      author: Author(name: client.user.username, iconUrl: client.user.decoration.defaultAvatarUrl)
    );

    embed.addField(name: 'Identifier', value: preview.id);
    embed.addField(name: 'Features', value: preview.features.map((feature) => '• $feature').join('\n'), inline: true);

    if (preview.stickers.isNotEmpty) {
      embed.addField(name: 'Emojis', value: preview.emojis.values.map((emoji) => emoji).join(' '), inline: true);
    }

    embed.addField(name: '\u200B', value: '\u200B');
    embed.addField(name: 'Online members', value: '${preview.approximatePresenceCount} members', inline: true);
    embed.addField(name: 'Members', value: '${preview.approximateMemberCount} members', inline: true);
    embed.addField(name: '\u200B', value: '\u200B', inline: true);

    return embed;
  }
}
