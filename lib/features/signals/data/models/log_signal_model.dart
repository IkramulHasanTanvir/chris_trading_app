class LogTradingSignalModel {
  final String signalId;
  final double entryPrice;
  final double stopLoss;
  final double exitPrice; // Target in UI; kept as exitPrice for API compat
  final double lotSize;
  final double resultPnl;
  final String outcome;
  final String notes;
  final String screenshotUrl;
  final String externalPlatform;
  final String pnlUnit;

  LogTradingSignalModel({
    required this.signalId,
    required this.entryPrice,
    required this.stopLoss,
    required this.exitPrice,
    required this.lotSize,
    required this.resultPnl,
    required this.outcome,
    required this.notes,
    required this.screenshotUrl,
    required this.externalPlatform,
    this.pnlUnit = 'usd',
  });

  factory LogTradingSignalModel.fromJson(Map<String, dynamic> json) {
    return LogTradingSignalModel(
      signalId: json['signalId'] ?? '',
      entryPrice: (json['entryPrice'] ?? 0).toDouble(),
      stopLoss: (json['stopLoss'] ?? 0).toDouble(),
      exitPrice: (json['exitPrice'] ?? json['targetPrice'] ?? 0).toDouble(),
      lotSize: (json['lotSize'] ?? 0).toDouble(),
      resultPnl: (json['resultPnl'] ?? 0).toDouble(),
      outcome: json['outcome'] ?? '',
      notes: json['notes'] ?? '',
      screenshotUrl: json['screenshotUrl'] ?? '',
      externalPlatform: json['externalPlatform'] ?? '',
      pnlUnit: json['pnlUnit'] ?? 'usd',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'signalId': signalId,
      'entryPrice': entryPrice,
      'stopLoss': stopLoss,
      'exitPrice': exitPrice,
      'targetPrice': exitPrice,
      'lotSize': lotSize,
      'resultPnl': resultPnl,
      'outcome': outcome,
      'notes': notes,
      'screenshotUrl': screenshotUrl,
      'externalPlatform': externalPlatform,
      'pnlUnit': pnlUnit,
    };
  }
}
