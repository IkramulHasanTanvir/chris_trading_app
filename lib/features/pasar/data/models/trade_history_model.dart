class TradeHistoryModel {
  final List<Trades>? trades;
  final Summary? summary;

  TradeHistoryModel({
    this.trades,
    this.summary,
  });

  factory TradeHistoryModel.fromJson(Map<String, dynamic> json) {
    return TradeHistoryModel(
      trades: json['trades'] != null
          ? (json['trades'] as List)
          .map((e) => Trades.fromJson(e))
          .toList()
          : null,
      summary:
      json['summary'] != null ? Summary.fromJson(json['summary']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'trades': trades?.map((e) => e.toJson()).toList(),
      'summary': summary?.toJson(),
    };
  }
}

class Trades {
  final String? sId;
  final String? userId;
  final SignalId? signalId;
  final MasterId? masterId;
  final String? status;
  final double? entryPrice;
  final double? exitPrice;
  final double? lotSize;
  final int? resultPnl;
  final String? outcome;
  final String? notes;
  final String? screenshotUrl;
  final String? externalPlatform;
  final String? loggedAt;
  final String? copiedAt;
  final String? createdAt;
  final String? updatedAt;

  Trades({
    this.sId,
    this.userId,
    this.signalId,
    this.masterId,
    this.status,
    this.entryPrice,
    this.exitPrice,
    this.lotSize,
    this.resultPnl,
    this.outcome,
    this.notes,
    this.screenshotUrl,
    this.externalPlatform,
    this.loggedAt,
    this.copiedAt,
    this.createdAt,
    this.updatedAt,
  });

  factory Trades.fromJson(Map<String, dynamic> json) {
    return Trades(
      sId: json['_id'],
      userId: json['userId'],
      signalId: json['signalId'] != null
          ? SignalId.fromJson(json['signalId'])
          : null,
      masterId: json['masterId'] != null
          ? MasterId.fromJson(json['masterId'])
          : null,
      status: json['status'],
      entryPrice: (json['entryPrice'] as num?)?.toDouble(),
      exitPrice: (json['exitPrice'] as num?)?.toDouble(),
      lotSize: (json['lotSize'] as num?)?.toDouble(),
      resultPnl: (json['resultPnl'] as num?)?.toInt(),
      outcome: json['outcome'],
      notes: json['notes'],
      screenshotUrl: json['screenshotUrl'],
      externalPlatform: json['externalPlatform'],
      loggedAt: json['loggedAt'],
      copiedAt: json['copiedAt'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': sId,
      'userId': userId,
      'signalId': signalId?.toJson(),
      'masterId': masterId?.toJson(),
      'status': status,
      'entryPrice': entryPrice,
      'exitPrice': exitPrice,
      'lotSize': lotSize,
      'resultPnl': resultPnl,
      'outcome': outcome,
      'notes': notes,
      'screenshotUrl': screenshotUrl,
      'externalPlatform': externalPlatform,
      'loggedAt': loggedAt,
      'copiedAt': copiedAt,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}

class SignalId {
  final String? sId;
  final String? title;
  final String? assetType;
  final String? symbol;
  final String? signalType;
  final double? entryPrice;
  final String? status;

  SignalId({
    this.sId,
    this.title,
    this.assetType,
    this.symbol,
    this.signalType,
    this.entryPrice,
    this.status,
  });

  factory SignalId.fromJson(Map<String, dynamic> json) {
    return SignalId(
      sId: json['_id'],
      title: json['title'],
      assetType: json['assetType'],
      symbol: json['symbol'],
      signalType: json['signalType'],
      entryPrice: (json['entryPrice'] as num?)?.toDouble(),
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': sId,
      'title': title,
      'assetType': assetType,
      'symbol': symbol,
      'signalType': signalType,
      'entryPrice': entryPrice,
      'status': status,
    };
  }
}

class MasterId {
  final String? sId;
  final String? name;
  final String? userProfileUrl;

  MasterId({
    this.sId,
    this.name,
    this.userProfileUrl,
  });

  factory MasterId.fromJson(Map<String, dynamic> json) {
    return MasterId(
      sId: json['_id'],
      name: json['name'],
      userProfileUrl: json['userProfileUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': sId,
      'name': name,
      'userProfileUrl': userProfileUrl,
    };
  }
}

class Summary {
  final int? totalTrades;
  final int? completedTrades;
  final int? pendingTrades;
  final int? wins;
  final int? losses;
  final int? breakevens;
  final int? winRate;
  final int? totalPnl;

  Summary({
    this.totalTrades,
    this.completedTrades,
    this.pendingTrades,
    this.wins,
    this.losses,
    this.breakevens,
    this.winRate,
    this.totalPnl,
  });

  factory Summary.fromJson(Map<String, dynamic> json) {
    return Summary(
      totalTrades: (json['totalTrades'] as num?)?.toInt(),
      completedTrades: (json['completedTrades'] as num?)?.toInt(),
      pendingTrades: (json['pendingTrades'] as num?)?.toInt(),
      wins: (json['wins'] as num?)?.toInt(),
      losses: (json['losses'] as num?)?.toInt(),
      breakevens: (json['breakevens'] as num?)?.toInt(),
      winRate: (json['winRate'] as num?)?.toInt(),
      totalPnl: (json['totalPnl'] as num?)?.toInt(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalTrades': totalTrades,
      'completedTrades': completedTrades,
      'pendingTrades': pendingTrades,
      'wins': wins,
      'losses': losses,
      'breakevens': breakevens,
      'winRate': winRate,
      'totalPnl': totalPnl,
    };
  }
}
