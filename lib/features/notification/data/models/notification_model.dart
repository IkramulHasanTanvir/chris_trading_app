class NotificationModel {
  String? sId;
  String? accountId;
  String? type;
  String? title;
  String? message;
  bool? isRead;
  String? link;
  Data? data;
  String? createdAt;
  String? updatedAt;

  NotificationModel({
    this.sId,
    this.accountId,
    this.type,
    this.title,
    this.message,
    this.isRead,
    this.link,
    this.data,
    this.createdAt,
    this.updatedAt,
  });

  NotificationModel.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    accountId = json['accountId'];
    type = json['type'];
    title = json['title'];
    message = json['message'];
    isRead = json['isRead'];
    link = json['link'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['accountId'] = accountId;
    data['type'] = type;
    data['title'] = title;
    data['message'] = message;
    data['isRead'] = isRead;
    data['link'] = link;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }
}

class Data {
  String? badgeKey;
  String? badgeName;
  String? signalId;
  String? symbol;
  String? signalType;

  Data({
    this.badgeKey,
    this.badgeName,
    this.signalId,
    this.symbol,
    this.signalType,
  });

  Data.fromJson(Map<String, dynamic> json) {
    badgeKey = json['badgeKey'];
    badgeName = json['badgeName'];
    signalId = json['signalId'];
    symbol = json['symbol'];
    signalType = json['signalType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['badgeKey'] = badgeKey;
    data['badgeName'] = badgeName;
    data['signalId'] = signalId;
    data['symbol'] = symbol;
    data['signalType'] = signalType;
    return data;
  }
}
