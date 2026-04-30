class AppConstants{
  AppConstants._();
  static const String accessToken = "accessToken";
  static const String refreshToken = "refreshToken";
  static const String cacheUserRole = "cacheUserRole";
  static const String cacheUser = "cacheUser";
  static const String cacheReferralData = "cacheReferralData";
  static const String cacheWithdrawalData = "cacheWithdrawalData";
  static const String cacheLeaderBoard = "cacheLeaderBoard";
  static const String cacheTrader = "cacheTrader";
  static const String cacheContributor = "cacheContributor";
  static const String cacheSignals = "cacheSignals";
  static const String cacheFollowTrader = "cacheFollowTrader";
  static const String cacheTradeHistoryPending = 'trade_history_pending';
  static const String cacheTradeHistoryCompleted = 'trade_history_completed';
  static const String twoFactorSetUp = 'twoFactorSetUp';





















  static RegExp emailValidate = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

  static bool validatePassword(String value) {
    RegExp regex = RegExp(r'^(?=.*[0-9])(?=.*[a-zA-Z]).{6,}$');
    return regex.hasMatch(value);
  }



}