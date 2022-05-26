part of api;

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

  Field({ required this.name, required this.value, required this.inline });

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
  Author? author;
  List<Field> fields = [];
  Color?
  color;

  MessageEmbed setTitle (String value) {
    title = value;
    return this;
  }

  MessageEmbed setDescription (String value) {
    description = value;
    return this;
  }

  MessageEmbed setFooter ({ required String text, String? iconUrl, String? proxyIconUrl }) {
    footer = Footer(text: text, iconUrl: iconUrl, proxyIconUrl: proxyIconUrl);
    return this;
  }

  MessageEmbed setImage ({ required String url, String? proxyUrl, int? width, int? height }) {
    image = Image(url: url, proxyUrl: proxyUrl, width: width, height: height);
    return this;
  }

  MessageEmbed setAuthor ({ required String name, String? url, String? iconUrl, String? proxyIconUrl }) {
    author = Author(name: name, url: url, iconUrl: iconUrl, proxyIconUrl: proxyIconUrl);
    return this;
  }

  MessageEmbed setColor (Color color) {
    this.color = color;
    return this;
  }

  MessageEmbed setTimestamp ({ DateTime? dateTime }) {
    timestamp = dateTime ?? DateTime.now();
    return this;
  }

  MessageEmbed setUrl (String url) {
    this.url = url;
    return this;
  }

  MessageEmbed addField ({ required String name, required String value, bool? inline }) {
    fields.add(Field(name: name, value: value, inline: inline));
    return this;
  }

  Object toJson () {
    List<dynamic> fields = [];
    for (Field field in this.fields) {
      fields.add(field.toJson());
    }

    return {
      'title': title,
      'description': description,
      'footer': footer?.toJson(),
      'timestamp': timestamp?.toIso8601String(),
      'fields': fields,
      'color': color != null ? int.parse(color.toString().replaceAll('#', ''), radix: 16) : null
    };
  }
}
