class LogTradingSignalModel {
  final String signalId;
  final double entryPrice;
  final double exitPrice;
  final double lotSize;
  final double resultPnl;
  final String outcome;
  final String notes;
  final String screenshotUrl;
  final String externalPlatform;

  // {
  // "signalId": "string",
  // "entryPrice": 1.085,
  // "exitPrice": 1.092,
  // "lotSize": 0.5,
  // "resultPnl": 350,
  // "outcome": "win",
  // "notes": "Followed master's TP2 target",
  // "screenshotUrl": "https://example.com/screenshot.png",
  // "externalPlatform": "binance"


  LogTradingSignalModel({
    required this.signalId,
    required this.entryPrice,
    required this.exitPrice,
    required this.lotSize,
    required this.resultPnl,
    required this.outcome,
    required this.notes,
    required this.screenshotUrl,
    required this.externalPlatform,
  });

  /// Convert JSON -> Model
  factory LogTradingSignalModel.fromJson(Map<String, dynamic> json) {
    return LogTradingSignalModel(
      signalId: json['signalId'] ?? '',
      entryPrice: (json['entryPrice'] ?? 0).toDouble(),
      exitPrice: (json['exitPrice'] ?? 0).toDouble(),
      lotSize: (json['lotSize'] ?? 0).toDouble(),
      resultPnl: (json['resultPnl'] ?? 0).toDouble(),
      outcome: json['outcome'] ?? '',
      notes: json['notes'] ?? '',
      screenshotUrl: json['screenshotUrl'] ?? '',
      externalPlatform: json['externalPlatform'] ?? '',
    );
  }

  /// Convert Model -> JSON
  Map<String, dynamic> toJson() {
    return {
      "signalId": signalId,
      "entryPrice": entryPrice,
      "exitPrice": exitPrice,
      "lotSize": lotSize,
      "resultPnl": resultPnl,
      "outcome": outcome,
      "notes": notes,
      "screenshotUrl": screenshotUrl,
      "externalPlatform": externalPlatform,
    };
  }
}
