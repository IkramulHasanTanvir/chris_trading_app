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

  static LeaderBoardModel demoLeaderBoard = LeaderBoardModel(
    leaderBoardItems: [
      LeaderBoardItem(
        sId: "1",
        accountId: AccountId(
          sId: "u1",
          name: "Tanvir Pro",
          email: "tanvir@mail.com",
          userProfileUrl: "https://i.pravatar.cc/150?img=1",
        ),
        bio: "Forex Expert",
        specialties: ["Forex", "Gold"],
        winRate: 92,
        avgPnl: 340,
        followerCount: 1200,
        totalSignals: 150,
        isFeatured: true,
        leaderboardScore: 100,
      ),
      LeaderBoardItem(
        sId: "2",
        accountId: AccountId(
          sId: "u2",
          name: "Rahim Trader",
          email: "rahim@mail.com",
          userProfileUrl: "https://i.pravatar.cc/150?img=2",
        ),
        bio: "Crypto Specialist",
        specialties: ["BTC", "ETH"],
        winRate: 88,
        avgPnl: 280,
        followerCount: 980,
        totalSignals: 130,
        leaderboardScore: 90,
      ),
      LeaderBoardItem(
        sId: "3",
        accountId: AccountId(
          sId: "u3",
          name: "Karim Signals",
          email: "karim@mail.com",
          userProfileUrl: "https://i.pravatar.cc/150?img=3",
        ),
        bio: "Stock Market Analyst",
        specialties: ["Stocks"],
        winRate: 85,
        avgPnl: 250,
        followerCount: 870,
        totalSignals: 120,
        leaderboardScore: 80,
      ),
      LeaderBoardItem(
        sId: "4",
        accountId: AccountId(
          sId: "u4",
          name: "Nayeem FX",
          email: "nayeem@mail.com",
          userProfileUrl: "https://i.pravatar.cc/150?img=4",
        ),
        bio: "Scalping Expert",
        specialties: ["Scalping"],
        winRate: 82,
        avgPnl: 210,
        followerCount: 650,
        totalSignals: 100,
        leaderboardScore: 70,
      ),
    ],
    topThree: [
      LeaderBoardItem(
        sId: "1",
        accountId: AccountId(
          name: "Tanvir Pro",
          userProfileUrl: "https://i.pravatar.cc/150?img=1",
        ),
        leaderboardScore: 100,
      ),
      LeaderBoardItem(
        sId: "2",
        accountId: AccountId(
          name: "Rahim Trader",
          userProfileUrl: "https://i.pravatar.cc/150?img=2",
        ),
        leaderboardScore: 90,
      ),
      LeaderBoardItem(
        sId: "3",
        accountId: AccountId(
          name: "Karim Signals",
          userProfileUrl: "https://i.pravatar.cc/150?img=3",
        ),
        leaderboardScore: 80,
      ),
    ],
    stats: Stats(
      totalMasters: 50,
      avgWinRate: 87.5,
      totalSignals: 5000,
      totalFollowers: 15000,
    ),
  );
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