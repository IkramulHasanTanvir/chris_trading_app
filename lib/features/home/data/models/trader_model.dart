class TraderModel {
  String? sId;
  AccountId? accountId;
  String? name;
  String? userProfileUrl;
  String? bio;
  List<String>? specialties;
  int? winRate;
  int? avgPnl;
  int? totalSignals;
  int? winningSignals;
  int? losingSignals;
  int? followerCount;
  bool? isFeatured;
  int? recentSignalsCount;
  int? rank;

  TraderModel({
    this.sId,
    this.accountId,
    this.name,
    this.userProfileUrl,
    this.bio,
    this.specialties,
    this.winRate,
    this.avgPnl,
    this.totalSignals,
    this.winningSignals,
    this.losingSignals,
    this.followerCount,
    this.isFeatured,
    this.recentSignalsCount,
    this.rank,
  });

  TraderModel.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    accountId = json['accountId'] != null
        ? new AccountId.fromJson(json['accountId'])
        : null;
    name = json['name'];
    userProfileUrl = json['userProfileUrl'];
    bio = json['bio'];
    specialties = json['specialties'].cast<String>();
    winRate = json['winRate'];
    avgPnl = json['avgPnl'];
    totalSignals = json['totalSignals'];
    winningSignals = json['winningSignals'];
    losingSignals = json['losingSignals'];
    followerCount = json['followerCount'];
    isFeatured = json['isFeatured'];
    recentSignalsCount = json['recentSignalsCount'];
    rank = json['rank'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    if (this.accountId != null) {
      data['accountId'] = this.accountId!.toJson();
    }
    data['name'] = this.name;
    data['userProfileUrl'] = this.userProfileUrl;
    data['bio'] = this.bio;
    data['specialties'] = this.specialties;
    data['winRate'] = this.winRate;
    data['avgPnl'] = this.avgPnl;
    data['totalSignals'] = this.totalSignals;
    data['winningSignals'] = this.winningSignals;
    data['losingSignals'] = this.losingSignals;
    data['followerCount'] = this.followerCount;
    data['isFeatured'] = this.isFeatured;
    data['recentSignalsCount'] = this.recentSignalsCount;
    data['rank'] = this.rank;
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['name'] = this.name;
    data['email'] = this.email;
    data['userProfileUrl'] = this.userProfileUrl;
    return data;
  }
}
