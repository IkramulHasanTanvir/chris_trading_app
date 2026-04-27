class SignalsModel {
  String? sId;
  AuthorId? authorId;
  String? title;
  String? description;
  String? assetType;
  String? symbol;
  String? signalType;
  String? timeframe;
  int? entryPrice;
  String? entryNotes;
  int? stopLoss;
  int? takeProfit1;
  dynamic takeProfit2;
  dynamic takeProfit3;
  String? status;
  String? publishType;
  dynamic scheduledAt;
  String? publishedAt;
  bool? isFeatured;
  bool? isPremium;
  dynamic resultPnl;
  dynamic closedAt;
  String? closeNotes;
  int? viewCount;
  int? likeCount;
  int? bookmarkCount;
  int? commentCount;
  int? copierCount;
  List<String>? tags;
  String? externalChartUrl;
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

    entryPrice = json['entryPrice'] is int
        ? json['entryPrice']
        : int.tryParse(json['entryPrice']?.toString() ?? '');

    entryNotes = json['entryNotes'];

    stopLoss = json['stopLoss'] is int
        ? json['stopLoss']
        : int.tryParse(json['stopLoss']?.toString() ?? '');

    takeProfit1 = json['takeProfit1'] is int
        ? json['takeProfit1']
        : int.tryParse(json['takeProfit1']?.toString() ?? '');

    takeProfit2 = json['takeProfit2'];
    takeProfit3 = json['takeProfit3'];

    status = json['status'];
    publishType = json['publishType'];
    scheduledAt = json['scheduledAt'];
    publishedAt = json['publishedAt'];

    isFeatured = json['isFeatured'] ?? false;
    isPremium = json['isPremium'] ?? false;

    resultPnl = json['resultPnl'];
    closedAt = json['closedAt'];
    closeNotes = json['closeNotes'];

    viewCount = json['viewCount'] ?? 0;
    likeCount = json['likeCount'] ?? 0;
    bookmarkCount = json['bookmarkCount'] ?? 0;
    commentCount = json['commentCount'] ?? 0;
    copierCount = json['copierCount'] ?? 0;

    tags = json['tags'] != null ? List<String>.from(json['tags']) : [];

    externalChartUrl = json['externalChartUrl'];
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
      'isFeatured': isFeatured ?? false,
      'isPremium': isPremium ?? false,
      'resultPnl': resultPnl,
      'closedAt': closedAt,
      'closeNotes': closeNotes,
      'viewCount': viewCount ?? 0,
      'likeCount': likeCount ?? 0,
      'bookmarkCount': bookmarkCount ?? 0,
      'commentCount': commentCount ?? 0,
      'copierCount': copierCount ?? 0,
      'tags': tags ?? [],
      'externalChartUrl': externalChartUrl,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }


  static final List<SignalsModel> demoSignals = [
    SignalsModel.fromJson({
      "_id": "1",
      "authorId": {
        "_id": "a1",
        "name": "Tanvir",
        "userProfileUrl": "https://i.pravatar.cc/150?img=1"
      },
      "title": "BTC Buy Signal",
      "description": "Strong bullish momentum দেখা যাচ্ছে",
      "assetType": "Crypto",
      "symbol": "BTC/USDT",
      "signalType": "Buy",
      "timeframe": "1H",
      "entryPrice": 65000,
      "stopLoss": 64000,
      "takeProfit1": 67000,
      "status": "Open",
      "publishType": "Public",
      "publishedAt": "2026-04-25",
      "isFeatured": true,
      "isPremium": false,
      "viewCount": 120,
      "likeCount": 45,
      "bookmarkCount": 12,
      "commentCount": 8,
      "copierCount": 20,
      "tags": ["BTC", "Crypto", "Scalp"]
    }),

    SignalsModel.fromJson({
      "_id": "2",
      "authorId": {
        "_id": "a2",
        "name": "Rahim",
        "userProfileUrl": "https://i.pravatar.cc/150?img=2"
      },
      "title": "Gold Sell Setup",
      "description": "Resistance hit করছে",
      "assetType": "Forex",
      "symbol": "XAU/USD",
      "signalType": "Sell",
      "timeframe": "4H",
      "entryPrice": 2350,
      "stopLoss": 2380,
      "takeProfit1": 2280,
      "status": "Open",
      "publishType": "Public",
      "publishedAt": "2026-04-25",
      "isFeatured": false,
      "isPremium": true,
      "viewCount": 98,
      "likeCount": 30,
      "bookmarkCount": 10,
      "commentCount": 5,
      "copierCount": 15,
      "tags": ["Gold", "Forex"]
    }),

    SignalsModel.fromJson({
      "_id": "3",
      "authorId": {
        "_id": "a3",
        "name": "Karim",
        "userProfileUrl": "https://i.pravatar.cc/150?img=3"
      },
      "title": "ETH Breakout",
      "description": "Breakout confirmed 🚀",
      "assetType": "Crypto",
      "symbol": "ETH/USDT",
      "signalType": "Buy",
      "timeframe": "15M",
      "entryPrice": 3200,
      "stopLoss": 3100,
      "takeProfit1": 3400,
      "status": "Closed",
      "publishType": "Public",
      "publishedAt": "2026-04-24",
      "isFeatured": true,
      "isPremium": false,
      "viewCount": 200,
      "likeCount": 80,
      "bookmarkCount": 25,
      "commentCount": 15,
      "copierCount": 50,
      "tags": ["ETH", "Breakout"]
    }),

    SignalsModel.fromJson({
      "_id": "4",
      "authorId": {
        "_id": "a4",
        "name": "Sakib",
        "userProfileUrl": "https://i.pravatar.cc/150?img=4"
      },
      "title": "EURUSD Reversal",
      "description": "Trend reversal possible",
      "assetType": "Forex",
      "symbol": "EUR/USD",
      "signalType": "Buy",
      "timeframe": "1D",
      "entryPrice": 1,
      "stopLoss": 0,
      "takeProfit1": 2,
      "status": "Open",
      "publishType": "Private",
      "publishedAt": "2026-04-23",
      "isFeatured": false,
      "isPremium": true,
      "viewCount": 60,
      "likeCount": 20,
      "bookmarkCount": 5,
      "commentCount": 2,
      "copierCount": 8,
      "tags": ["EURUSD"]
    }),
  ];

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
