class SignalsModel {
  String? sId;
  AuthorId? authorId;
  String? title;
  String? description;
  String? assetType;
  String? symbol;
  String? signalType;
  String? timeframe;

  double? entryPrice;
  String? entryNotes;
  double? stopLoss;
  double? takeProfit1;
  double? takeProfit2;
  double? takeProfit3;

  String? status;
  String? publishType;
  dynamic scheduledAt;
  String? publishedAt;

  bool? isFeatured;
  bool? isPremium;
  bool? isCopied;

  double? resultPnl;
  String? pnlUnit;
  dynamic closedAt;
  String? closeNotes;

  int? viewCount;
  int? likeCount;
  int? bookmarkCount;
  int? commentCount;
  int? copierCount;

  List<String>? tags;

  String? externalChartUrl;
  String? videoUrl;

  String? workflowStatus;

  dynamic aiValidation;
  dynamic mtReview;

  String? createdAt;
  String? updatedAt;

  SignalsModel.fromJson(Map<String, dynamic> json) {
    sId = json['_id']?.toString();

    authorId = json['authorId'] != null
        ? AuthorId.fromJson(json['authorId'])
        : null;

    title = json['title'] ?? '';
    description = json['description'] ?? '';

    assetType = json['assetType'];
    symbol = json['symbol'];
    signalType = json['signalType'];
    timeframe = json['timeframe'];

    entryPrice = (json['entryPrice'] as num?)?.toDouble();

    entryNotes = json['entryNotes'];

    stopLoss = (json['stopLoss'] as num?)?.toDouble();

    takeProfit1 = (json['takeProfit1'] as num?)?.toDouble();

    takeProfit2 = (json['takeProfit2'] as num?)?.toDouble();

    takeProfit3 = (json['takeProfit3'] as num?)?.toDouble();

    status = json['status'];
    publishType = json['publishType'];
    scheduledAt = json['scheduledAt'];
    publishedAt = json['publishedAt'];

    isFeatured = json['isFeatured'] ?? false;
    isPremium = json['isPremium'] ?? false;
    isCopied = json['isCopied'] ?? false;

    resultPnl = (json['resultPnl'] as num?)?.toDouble();
    pnlUnit = json['pnlUnit'] ?? 'usd';

    closedAt = json['closedAt'];
    closeNotes = json['closeNotes'];

    viewCount = json['viewCount'] ?? 0;
    likeCount = json['likeCount'] ?? 0;
    bookmarkCount = json['bookmarkCount'] ?? 0;
    commentCount = json['commentCount'] ?? 0;
    copierCount = json['copierCount'] ?? 0;

    tags = json['tags'] != null
        ? List<String>.from(json['tags'])
        : [];

    externalChartUrl = json['externalChartUrl'];
    videoUrl = json['videoUrl'];

    workflowStatus = json['workflowStatus'];

    aiValidation = json['aiValidation'];
    mtReview = json['mtReview'];

    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': sId,
      'authorId': authorId?.toJson(),
      'title': title,
      'description': description,
      'assetType': assetType,
      'symbol': symbol,
      'signalType': signalType,
      'timeframe': timeframe,
      'entryPrice': entryPrice,
      'entryNotes': entryNotes,
      'stopLoss': stopLoss,
      'takeProfit1': takeProfit1,
      'takeProfit2': takeProfit2,
      'takeProfit3': takeProfit3,
      'status': status,
      'publishType': publishType,
      'scheduledAt': scheduledAt,
      'publishedAt': publishedAt,
      'isFeatured': isFeatured,
      'isPremium': isPremium,
      'isCopied': isCopied,
      'resultPnl': resultPnl,
      'pnlUnit': pnlUnit,
      'closedAt': closedAt,
      'closeNotes': closeNotes,
      'viewCount': viewCount,
      'likeCount': likeCount,
      'bookmarkCount': bookmarkCount,
      'commentCount': commentCount,
      'copierCount': copierCount,
      'tags': tags,
      'externalChartUrl': externalChartUrl,
      'videoUrl': videoUrl,
      'workflowStatus': workflowStatus,
      'aiValidation': aiValidation,
      'mtReview': mtReview,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}
class AuthorId {
  String? sId;
  String? name;
  String? userProfileUrl;

  AuthorId.fromJson(Map<String, dynamic> json) {
    sId = json['_id']?.toString();
    name = json['name'] ?? '';
    userProfileUrl = json['userProfileUrl'] ?? '';
  }

  Map<String, dynamic> toJson() {
    return {'_id': sId, 'name': name, 'userProfileUrl': userProfileUrl};
  }
}
