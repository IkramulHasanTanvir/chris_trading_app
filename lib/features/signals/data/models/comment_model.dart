class CommentModel {
  String? sId;
  String? signalId;
  String? message;
  UserId? userId;
  String? createdAt;
  bool? isPending;

  CommentModel({
    this.sId,
    this.signalId,
    this.message,
    this.userId,
    this.createdAt,
    this.isPending,
  });

  CommentModel.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    signalId = json['signalId'];
    message = json['message'];
    userId = json['userId'] != null ? UserId.fromJson(json['userId']) : null;
    createdAt = json['createdAt'];
    isPending = false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['signalId'] = signalId;
    data['message'] = message;
    if (userId != null) {
      data['userId'] = userId!.toJson();
    }
    data['createdAt'] = createdAt;
    return data;
  }
}

class UserId {
  String? sId;
  String? name;
  String? userProfileUrl;

  UserId({this.sId, this.name, this.userProfileUrl});

  UserId.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    userProfileUrl = json['userProfileUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['name'] = name;
    data['userProfileUrl'] = userProfileUrl;
    return data;
  }
}
