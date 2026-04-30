
class FollowTraderModel {
  String? sId;
  String? followerId;
  MasterId? masterId;
  bool? notificationsEnabled;
  String? createdAt;
  String? updatedAt;
  MasterId? master;

  FollowTraderModel(
      {this.sId,
        this.followerId,
        this.masterId,
        this.notificationsEnabled,
        this.createdAt,
        this.updatedAt,
        this.master});

  FollowTraderModel.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    followerId = json['followerId'];
    masterId = json['masterId'] != null
        ? new MasterId.fromJson(json['masterId'])
        : null;
    notificationsEnabled = json['notificationsEnabled'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    master =
    json['master'] != null ? new MasterId.fromJson(json['master']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['followerId'] = this.followerId;
    if (this.masterId != null) {
      data['masterId'] = this.masterId!.toJson();
    }
    data['notificationsEnabled'] = this.notificationsEnabled;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    if (this.master != null) {
      data['master'] = this.master!.toJson();
    }
    return data;
  }
}

class MasterId {
  String? sId;
  String? name;
  String? email;
  String? userProfileUrl;

  MasterId({this.sId, this.name, this.email, this.userProfileUrl});

  MasterId.fromJson(Map<String, dynamic> json) {
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