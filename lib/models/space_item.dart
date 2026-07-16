class SpaceItem {
  final String id;
  final String title;
  final String bannerType; // 'color', 'image', 'pattern'
  final String bannerValue;
  final String? bannerColor;

  SpaceItem({
    required this.id,
    required this.title,
    required this.bannerType,
    required this.bannerValue,
    this.bannerColor,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'bannerType': bannerType,
      'bannerValue': bannerValue,
      'bannerColor': bannerColor,
    };
  }

  factory SpaceItem.fromJson(Map<String, dynamic> json) {
    return SpaceItem(
      id: json['id'],
      title: json['title'],
      bannerType: json['bannerType'],
      bannerValue: json['bannerValue'],
      bannerColor: json['bannerColor'],
    );
  }
}

class LinkItem {
  final String id;
  final String title;
  final String url;
  final String? note;
  final List<String>? keywords;
  final int? timestamp;

  LinkItem({
    required this.id,
    required this.title,
    required this.url,
    this.note,
    this.keywords,
    this.timestamp,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'url': url,
      'note': note,
      'keywords': keywords,
      'timestamp': timestamp,
    };
  }

  factory LinkItem.fromJson(Map<String, dynamic> json) {
    return LinkItem(
      id: json['id'],
      title: json['title'],
      url: json['url'],
      note: json['note'],
      keywords: json['keywords'] != null
          ? List<String>.from(json['keywords'])
          : null,
      timestamp: json['timestamp'],
    );
  }
}
