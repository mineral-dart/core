import 'package:mineral/api.dart';
import 'package:mineral/core.dart';

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

class MessageEmbed {
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

  MessageEmbed({
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
  /// final embed = MessageEmbed()
  ///   .setTitle('My title');
  /// ```
  MessageEmbed setTitle (String value) {
    title = value;
    return this;
  }

  /// ### Set the [description] field and return this
  ///
  /// Example :
  /// ```dart
  /// final embed = MessageEmbed()
  ///   .setDescription('My description');
  /// ```
  MessageEmbed setDescription (String value) {
    description = value;
    return this;
  }

  /// ### Set the [footer] field and return this
  ///
  /// Example :
  /// ```dart
  /// final embed = MessageEmbed()
  ///   .setFooter(text: 'My title');
  /// ```
  MessageEmbed setFooter ({ required String text, String? iconUrl, String? proxyIconUrl }) {
    footer = Footer(text: text, iconUrl: iconUrl, proxyIconUrl: proxyIconUrl);
    return this;
  }

  /// ### Set the [image] field and return this
  ///
  /// Example :
  /// ```dart
  /// final embed = MessageEmbed()
  ///   .setImage(url: 'https://..../images/my_picture.png');
  /// ```
  MessageEmbed setImage ({ required String url, String? proxyUrl, int? width, int? height }) {
    image = Image(url: url, proxyUrl: proxyUrl, width: width, height: height);
    return this;
  }

  /// ### Set the [thumbnail] field and return this
  ///
  /// Example :
  /// ```dart
  /// final embed = MessageEmbed()
  ///   .setThumbnail(url: 'https://..../images/my_picture.png');
  /// ```
  MessageEmbed setThumbnail ({ required String url, String? proxyUrl, int? width, int? height }) {
    thumbnail = Thumbnail(url: url, proxyUrl: proxyUrl, width: width, height: height);
    return this;
  }

  /// ### Set the [author] field and return this
  ///
  /// Example :
  /// ```dart
  /// final embed = MessageEmbed()
  ///   .setAuthor(name: 'John Doe');
  /// ```
  MessageEmbed setAuthor ({ required String name, String? url, String? iconUrl, String? proxyIconUrl }) {
    author = Author(name: name, url: url, iconUrl: iconUrl, proxyIconUrl: proxyIconUrl);
    return this;
  }

  /// ### Set the [color] field and return this
  ///
  /// Example :
  /// ```dart
  /// final embed = MessageEmbed()
  ///   .setColor(Color.cyan_600);
  /// ```
  /// Or with your custom color
  ///
  /// Example :
  /// ```dart
  /// final embed = MessageEmbed()
  ///   .setColor(Color('#FFFFFF'));
  /// ```
  MessageEmbed setColor (Color color) {
    this.color = color;
    return this;
  }

  /// ### Set the [timestamp] field and return this
  ///
  /// Example :
  /// ```dart
  /// final embed = MessageEmbed()
  ///   .setTimestamp();
  /// ```
  /// You can define an older or future timestamp
  /// DateTime date = DateTime.now().add(DateTime(days: 5));
  /// final embed = MessageEmbed()
  ///   .setTimestamp(dateTime: date);
  /// ```
  MessageEmbed setTimestamp ({ DateTime? dateTime }) {
    timestamp = dateTime ?? DateTime.now();
    return this;
  }

  /// ### Set the [url] field and return this
  ///
  /// Example :
  /// ```dart
  /// final embed = MessageEmbed()
  ///   .setUrl('https://.....com');
  /// ```
  MessageEmbed setUrl (String url) {
    this.url = url;
    return this;
  }

  /// ### Add an field into [fields] and return this
  ///
  /// Example :
  /// ```dart
  /// final embed = MessageEmbed()
  ///   .addField(name: 'My field', value: 'My custom value');
  /// ```
  MessageEmbed addField ({ required String name, required String value, bool? inline }) {
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
      'footer': footer?.toJson(),
      'timestamp': timestamp?.toIso8601String(),
      'fields': fields,
      'color': color != null ? int.parse(color.toString().replaceAll('#', ''), radix: 16) : null,
      'image': image?.toJson(),
      'thumbnail': thumbnail?.toJson(),
      'author': author?.toJson(),
    };
  }

  factory MessageEmbed.fromGuildPreview(GuildPreview preview) {
    MineralClient client = ioc.singleton(ioc.services.client);

    final MessageEmbed embed = MessageEmbed(
      title: preview.label,
      description: preview.description,
      thumbnail: preview.icon != null ? Thumbnail(url: preview.icon!) : null,
      image: preview.discoverySplash != null ? Image(url: preview.discoverySplash!) : null,
      color: Color.invisible,
      timestamp: DateTime.now(),
      author: Author(name: client.user.username, iconUrl: client.user.getDisplayAvatarUrl())
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
