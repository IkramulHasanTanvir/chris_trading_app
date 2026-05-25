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
    if (summary != null) {
      data['summary'] = summary!.toJson();
    }
    if (winsLosses != null) {
      data['winsLosses'] = winsLosses!.toJson();
    }
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
  int? profitLoss;
  String? profitLossFormatted;
  String? currency;
  TopTradedAsset? topTradedAsset;

  Summary({
    this.winRate,
    this.totalTrades,
    this.profitLoss,
    this.profitLossFormatted,
    this.currency,
    this.topTradedAsset,
  });

  Summary.fromJson(Map<String, dynamic> json) {
    winRate = json['winRate'];
    totalTrades = json['totalTrades'];
    profitLoss = json['profitLoss'];
    profitLossFormatted = json['profitLossFormatted'];
    currency = json['currency'];
    topTradedAsset = json['topTradedAsset'] != null
        ? TopTradedAsset.fromJson(json['topTradedAsset'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['winRate'] = winRate;
    data['totalTrades'] = totalTrades;
    data['profitLoss'] = profitLoss;
    data['profitLossFormatted'] = profitLossFormatted;
    data['currency'] = currency;
    if (topTradedAsset != null) {
      data['topTradedAsset'] = topTradedAsset!.toJson();
    }
    return data;
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
    tradeCount = json['tradeCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['symbol'] = symbol;
    data['assetType'] = assetType;
    data['tradeCount'] = tradeCount;
    return data;
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
    final Map<String, dynamic> data = <String, dynamic>{};
    if (wins != null) {
      data['wins'] = wins!.toJson();
    }
    if (losses != null) {
      data['losses'] = losses!.toJson();
    }
    if (breakevens != null) {
      data['breakevens'] = breakevens!.toJson();
    }
    return data;
  }
}

class Wins {
  int? count;
  int? percentage;

  Wins({this.count, this.percentage});

  Wins.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    percentage = json['percentage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['count'] = count;
    data['percentage'] = percentage;
    return data;
  }
}

class Breakevens {
  int? count;

  Breakevens({this.count});

  Breakevens.fromJson(Map<String, dynamic> json) {
    count = json['count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['count'] = count;
    return data;
  }
}

class TradesByAsset {
  String? symbol;
  String? assetType;
  int? total;
  int? wins;
  int? losses;
  int? profitLoss;
  String? barColor;

  TradesByAsset({
    this.symbol,
    this.assetType,
    this.total,
    this.wins,
    this.losses,
    this.profitLoss,
    this.barColor,
  });

  TradesByAsset.fromJson(Map<String, dynamic> json) {
    symbol = json['symbol'];
    assetType = json['assetType'];
    total = json['total'];
    wins = json['wins'];
    losses = json['losses'];
    profitLoss = json['profitLoss'];
    barColor = json['barColor'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['symbol'] = symbol;
    data['assetType'] = assetType;
    data['total'] = total;
    data['wins'] = wins;
    data['losses'] = losses;
    data['profitLoss'] = profitLoss;
    data['barColor'] = barColor;
    return data;
  }
}

class TradeBars {
  String? symbol;
  String? assetType;
  String? outcome;
  int? profitLoss;
  String? barColor;
  String? loggedAt;

  TradeBars({
    this.symbol,
    this.assetType,
    this.outcome,
    this.profitLoss,
    this.barColor,
    this.loggedAt,
  });

  TradeBars.fromJson(Map<String, dynamic> json) {
    symbol = json['symbol'];
    assetType = json['assetType'];
    outcome = json['outcome'];
    profitLoss = json['profitLoss'];
    barColor = json['barColor'];
    loggedAt = json['loggedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['symbol'] = symbol;
    data['assetType'] = assetType;
    data['outcome'] = outcome;
    data['profitLoss'] = profitLoss;
    data['barColor'] = barColor;
    data['loggedAt'] = loggedAt;
    return data;
  }
}
