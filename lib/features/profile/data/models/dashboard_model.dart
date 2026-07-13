class DashboardModel {
  String? timeframe;
  Summary? summary;
  WinsLosses? winsLosses;
  List<TradesByAsset>? tradesByAsset;
  List<TradeBars>? tradeBars;

  DashboardModel({
    this.timeframe,
    this.summary,
    this.winsLosses,
    this.tradesByAsset,
    this.tradeBars,
  });

  DashboardModel.fromJson(Map<String, dynamic> json) {
    timeframe = json['timeframe'];
    summary = json['summary'] != null
        ? Summary.fromJson(json['summary'])
        : null;
    winsLosses = json['winsLosses'] != null
        ? WinsLosses.fromJson(json['winsLosses'])
        : null;
    if (json['tradesByAsset'] != null) {
      tradesByAsset = <TradesByAsset>[];
      json['tradesByAsset'].forEach((v) {
        tradesByAsset!.add(TradesByAsset.fromJson(v));
      });
    }
    if (json['tradeBars'] != null) {
      tradeBars = <TradeBars>[];
      json['tradeBars'].forEach((v) {
        tradeBars!.add(TradeBars.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['timeframe'] = timeframe;
    if (summary != null) data['summary'] = summary!.toJson();
    if (winsLosses != null) data['winsLosses'] = winsLosses!.toJson();
    if (tradesByAsset != null) {
      data['tradesByAsset'] = tradesByAsset!.map((v) => v.toJson()).toList();
    }
    if (tradeBars != null) {
      data['tradeBars'] = tradeBars!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Summary {
  int? winRate;
  int? totalTrades;
  num? profitLossUsd;
  num? profitLossPercent;
  String? currency;
  TopTradedAsset? topTradedAsset;

  Summary({
    this.winRate,
    this.totalTrades,
    this.profitLossUsd,
    this.profitLossPercent,
    this.currency,
    this.topTradedAsset,
  });

  Summary.fromJson(Map<String, dynamic> json) {
    winRate = (json['winRate'] as num?)?.toInt();
    totalTrades = (json['totalTrades'] as num?)?.toInt();
    profitLossUsd = json['profitLossUsd'] as num? ?? json['profitLoss'] as num?;
    profitLossPercent = json['profitLossPercent'] as num?;
    currency = json['currency'];
    topTradedAsset = json['topTradedAsset'] != null
        ? TopTradedAsset.fromJson(json['topTradedAsset'])
        : null;
  }

  Map<String, dynamic> toJson() {
    return {
      'winRate': winRate,
      'totalTrades': totalTrades,
      'profitLossUsd': profitLossUsd,
      'profitLossPercent': profitLossPercent,
      'currency': currency,
      'topTradedAsset': topTradedAsset?.toJson(),
    };
  }
}

class TopTradedAsset {
  String? symbol;
  String? assetType;
  int? tradeCount;

  TopTradedAsset({this.symbol, this.assetType, this.tradeCount});

  TopTradedAsset.fromJson(Map<String, dynamic> json) {
    symbol = json['symbol'];
    assetType = json['assetType'];
    tradeCount = (json['tradeCount'] as num?)?.toInt();
  }

  Map<String, dynamic> toJson() {
    return {
      'symbol': symbol,
      'assetType': assetType,
      'tradeCount': tradeCount,
    };
  }
}

class WinsLosses {
  Wins? wins;
  Wins? losses;
  Breakevens? breakevens;

  WinsLosses({this.wins, this.losses, this.breakevens});

  WinsLosses.fromJson(Map<String, dynamic> json) {
    wins = json['wins'] != null ? Wins.fromJson(json['wins']) : null;
    losses = json['losses'] != null ? Wins.fromJson(json['losses']) : null;
    breakevens = json['breakevens'] != null
        ? Breakevens.fromJson(json['breakevens'])
        : null;
  }

  Map<String, dynamic> toJson() {
    return {
      'wins': wins?.toJson(),
      'losses': losses?.toJson(),
      'breakevens': breakevens?.toJson(),
    };
  }
}

class Wins {
  int? count;
  int? percentage;

  Wins({this.count, this.percentage});

  Wins.fromJson(Map<String, dynamic> json) {
    count = (json['count'] as num?)?.toInt();
    percentage = (json['percentage'] as num?)?.toInt();
  }

  Map<String, dynamic> toJson() {
    return {'count': count, 'percentage': percentage};
  }
}

class Breakevens {
  int? count;

  Breakevens({this.count});

  Breakevens.fromJson(Map<String, dynamic> json) {
    count = (json['count'] as num?)?.toInt();
  }

  Map<String, dynamic> toJson() => {'count': count};
}

class TradesByAsset {
  String? symbol;
  String? assetType;
  int? total;
  int? wins;
  int? losses;
  num? profitLossUsd;
  num? profitLossPercent;
  String? barColor;

  TradesByAsset({
    this.symbol,
    this.assetType,
    this.total,
    this.wins,
    this.losses,
    this.profitLossUsd,
    this.profitLossPercent,
    this.barColor,
  });

  TradesByAsset.fromJson(Map<String, dynamic> json) {
    symbol = json['symbol'];
    assetType = json['assetType'];
    total = (json['total'] as num?)?.toInt();
    wins = (json['wins'] as num?)?.toInt();
    losses = (json['losses'] as num?)?.toInt();
    profitLossUsd =
        json['profitLossUsd'] as num? ?? json['profitLoss'] as num?;
    profitLossPercent = json['profitLossPercent'] as num?;
    barColor = json['barColor'];
  }

  Map<String, dynamic> toJson() {
    return {
      'symbol': symbol,
      'assetType': assetType,
      'total': total,
      'wins': wins,
      'losses': losses,
      'profitLossUsd': profitLossUsd,
      'profitLossPercent': profitLossPercent,
      'barColor': barColor,
    };
  }
}

class TradeBars {
  String? symbol;
  String? assetType;
  String? outcome;
  num? profitLoss;
  String? pnlUnit;
  String? barColor;
  String? loggedAt;

  TradeBars({
    this.symbol,
    this.assetType,
    this.outcome,
    this.profitLoss,
    this.pnlUnit,
    this.barColor,
    this.loggedAt,
  });

  TradeBars.fromJson(Map<String, dynamic> json) {
    symbol = json['symbol'];
    assetType = json['assetType'];
    outcome = json['outcome'];
    profitLoss = json['profitLoss'] as num?;
    pnlUnit = json['pnlUnit'] ?? 'usd';
    barColor = json['barColor'];
    loggedAt = json['loggedAt'];
  }

  Map<String, dynamic> toJson() {
    return {
      'symbol': symbol,
      'assetType': assetType,
      'outcome': outcome,
      'profitLoss': profitLoss,
      'pnlUnit': pnlUnit,
      'barColor': barColor,
      'loggedAt': loggedAt,
    };
  }
}
