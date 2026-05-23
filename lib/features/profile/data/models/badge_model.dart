class BadgeModel {
  String? role;
  List<Badges>? badges;
  Summary? summary;

  BadgeModel({this.role, this.badges, this.summary});

  BadgeModel.fromJson(Map<String, dynamic> json) {
    role = json['role'];
    if (json['badges'] != null) {
      badges = <Badges>[];
      json['badges'].forEach((v) {
        badges!.add(Badges.fromJson(v));
      });
    }
    summary = json['summary'] != null
        ? Summary.fromJson(json['summary'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['role'] = role;
    if (badges != null) {
      data['badges'] = badges!.map((v) => v.toJson()).toList();
    }
    if (summary != null) {
      data['summary'] = summary!.toJson();
    }
    return data;
  }
}

class Badges {
  String? key;
  String? name;
  String? description;
  String? iconKey;
  String? iconUrl;
  String? category;
  bool? earned;
  String? earnedAt;
  Progress? progress;

  Badges({
    this.key,
    this.name,
    this.description,
    this.iconKey,
    this.iconUrl,
    this.category,
    this.earned,
    this.earnedAt,
    this.progress,
  });

  Badges.fromJson(Map<String, dynamic> json) {
    key = json['key'];
    name = json['name'];
    description = json['description'];
    iconKey = json['iconKey'];
    iconUrl = json['iconUrl'];
    category = json['category'];
    earned = json['earned'];
    earnedAt = json['earnedAt'];
    progress = json['progress'] != null
        ? Progress.fromJson(json['progress'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['key'] = key;
    data['name'] = name;
    data['description'] = description;
    data['iconKey'] = iconKey;
    data['iconUrl'] = iconUrl;
    data['category'] = category;
    data['earned'] = earned;
    data['earnedAt'] = earnedAt;
    if (progress != null) {
      data['progress'] = progress!.toJson();
    }
    return data;
  }
}

class Progress {
  int? current;
  int? target;

  Progress({this.current, this.target});

  Progress.fromJson(Map<String, dynamic> json) {
    current = json['current'];
    target = json['target'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['current'] = current;
    data['target'] = target;
    return data;
  }
}

class Summary {
  int? earned;
  int? total;

  Summary({this.earned, this.total});

  Summary.fromJson(Map<String, dynamic> json) {
    earned = json['earned'];
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['earned'] = earned;
    data['total'] = total;
    return data;
  }
}
