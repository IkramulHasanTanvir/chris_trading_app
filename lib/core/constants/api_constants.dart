class ApiConstants {


  static const String baseUrl = 'https://reaz5000.syedbipul.me';
  //static const String baseUrl = 'http://206.162.244.11:7777/';

  /// ─── Auth Marker ───────────────────────────
  static const String requiresAuthHeader = 'X-Requires-Auth';
  static const Map<String, dynamic> headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  /// AUTH ──────────────────────────────────────────────

  static const String login = '/api/v1/auth/login';
  static const String register = '/api/v1/auth/register';
  static const String forgot = '/api/v1/auth/forgot-password';
  static const String otpVerify = '/api/v1/auth/verify-email';
  static const String resetPassword = '/api/v1/auth/reset-password';
  static const String twoFactorSetUp = '/api/v1/auth/2fa/setup';
  static const String twoFactorOtp = '/api/v1/auth/2fa/enable';
  static const String twoFactorDisable = '/api/v1/auth/2fa/disable';


  /// home
  static  String leaderboard(int page,int limit) => '/api/v1/leaderboard?timeframe=all&page=$page&limit=$limit';
  static  String topTrader(int page,int limit) => '/api/v1/top-traders?timeframe=all&sortBy=winRate&page=$page&limit=$limit';
  static  String contributions(int page,int limit) => '/api/v1/contributions/top-contributors?timeframe=all&page=$page&limit=$limit';

  // signal
  static  String signals(int page,int limit) => '/api/v1/signals?page=$page&limit=$limit';
  static  String follows(int page,int limit) => '/api/v1/follow/following?page=$page&limit=$limit';
  static  String tradesHistory(int page,int limit,String status) => '/api/v1/copied-trades?page=$page&limit=$limit&status=$status';
  static  String copySignals(String signalId) => '/api/v1/copied-trades/signals/$signalId/copy';
  static  String followTrader(String traderId) => '/api/v1/follow/toggle/$traderId';
  static const  String logSignals = '/api/v1/copied-trades/log';


  // profile
  static const String profile = '/api/v1/auth/me';
  static const String profileUpdate = '/api/v1/user/update-profile';
  static const String imageUpload = '/api/v1/upload/file';



  /// REFERRAL ──────────────────────────────────────────

  static const String referral = '/api/v1/referrals/stats';

  /// PROFILE ──────────────────────────────────────────
  static const String withdrawalRequest = '/api/v1/withdrawals/request';
  static  String myWithdrawals(int page) => '/api/v1/withdrawals/my-requests?page=$page&limit=20';




























  /// demo
  static const String config = '/api/v1/config';
  static const String banners = '/api/v1/banners';
  static const String categories = '/api/v1/categories';
  static const String popularFoods = '/api/v1/products/popular';
  static const String foodCampaigns = '/api/v1/campaigns/item';

  static String restaurants(int offset, int limit) =>
      '/api/v1/restaurants/get-restaurants/all?offset=$offset&limit=$limit';

  static const String cacheBanners = 'banners';
  static const String cacheCategories = 'categories';
  static const String cachePopularFoods = 'popularFoods';
  static const String cacheFoodCampaigns = 'foodCampaigns';
  static const String cacheRestaurants = 'restaurants';
  static const String cacheRestaurantsTotalSize = 'restaurantsTotalSize';
}
