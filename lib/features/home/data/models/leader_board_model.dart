class LeaderBoardModel {
  List<LeaderBoardItem>? leaderBoardItems;
  List<LeaderBoardItem>? topThree;
  Stats? stats;

  LeaderBoardModel({this.leaderBoardItems, this.topThree, this.stats});

  LeaderBoardModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      leaderBoardItems = <LeaderBoardItem>[];
      json['data'].forEach((v) {
        leaderBoardItems!.add(LeaderBoardItem.fromJson(v));
      });
    }
    if (json['topThree'] != null) {
      topThree = <LeaderBoardItem>[];
      json['topThree'].forEach((v) {
        topThree!.add(LeaderBoardItem.fromJson(v));
      });
    }
    stats = json['stats'] != null ? Stats.fromJson(json['stats']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (leaderBoardItems != null) {
      data['data'] = leaderBoardItems!.map((v) => v.toJson()).toList();
    }
    if (topThree != null) {
      data['topThree'] = topThree!.map((v) => v.toJson()).toList();
    }
    if (stats != null) {
      data['stats'] = stats!.toJson();
    }
    return data;
  }
}

class LeaderBoardItem {
  String? sId;
  AccountId? accountId;
  String? bio;
  List<String>? specialties;
  int? winRate;
  int? avgPnl;
  int? followerCount;
  int? totalSignals;
  bool? isFeatured;
  double? leaderboardScore;

  LeaderBoardItem({
    this.sId,
    this.accountId,
    this.bio,
    this.specialties,
    this.winRate,
    this.avgPnl,
    this.followerCount,
    this.totalSignals,
    this.isFeatured,
    this.leaderboardScore,
  });

  LeaderBoardItem.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    accountId = json['accountId'] != null
        ? AccountId.fromJson(json['accountId'])
        : null;
    bio = json['bio'];
    specialties = (json['specialties'] as List?)?.cast<String>() ?? [];
    winRate = (json['winRate'] as num?)?.toInt();
    avgPnl = (json['avgPnl'] as num?)?.toInt();
    followerCount = (json['followerCount'] as num?)?.toInt();
    totalSignals = (json['totalSignals'] as num?)?.toInt();
    isFeatured = json['isFeatured'];
    leaderboardScore = (json['leaderboardScore'] as num?)?.toDouble();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    if (accountId != null) {
      data['accountId'] = accountId!.toJson();
    }
    data['bio'] = bio;
    data['specialties'] = specialties;
    data['winRate'] = winRate;
    data['avgPnl'] = avgPnl;
    data['followerCount'] = followerCount;
    data['totalSignals'] = totalSignals;
    data['isFeatured'] = isFeatured;
    data['leaderboardScore'] = leaderboardScore;
    return data;
  }
}

class AccountId {
  String? sId;
  String? name;
  String? email;
  String? userProfileUrl;

  AccountId({this.sId, this.name, this.email, this.userProfileUrl});

  AccountId.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    email = json['email'];
    userProfileUrl = json['userProfileUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['name'] = name;
    data['email'] = email;
    data['userProfileUrl'] = userProfileUrl;
    return data;
  }
}

class Stats {
  int? totalMasters;
  double? avgWinRate;
  int? totalSignals;
  int? totalFollowers;

  Stats({
    this.totalMasters,
    this.avgWinRate,
    this.totalSignals,
    this.totalFollowers,
  });

  Stats.fromJson(Map<String, dynamic> json) {
    totalMasters = (json['totalMasters'] as num?)?.toInt();
    avgWinRate = (json['avgWinRate'] as num?)?.toDouble();
    totalSignals = (json['totalSignals'] as num?)?.toInt();
    totalFollowers = (json['totalFollowers'] as num?)?.toInt();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['totalMasters'] = totalMasters;
    data['avgWinRate'] = avgWinRate;
    data['totalSignals'] = totalSignals;
    data['totalFollowers'] = totalFollowers;
    return data;
  }
}