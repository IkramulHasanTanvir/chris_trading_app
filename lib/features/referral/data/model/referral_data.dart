class ReferralData {
  final String referralCode;
  final String referralLink;
  final int totalReferrals;
  final int activeReferrals;
  final double totalRewards;

  const ReferralData({
    required this.referralCode,
    required this.referralLink,
    required this.totalReferrals,
    required this.activeReferrals,
    required this.totalRewards,
  });

  factory ReferralData.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>;
    return ReferralData(
      referralCode: data['referralCode'] as String,
      referralLink: data['referralLink'] as String,
      totalReferrals: data['totalReferrals'] as int,
      activeReferrals: data['activeReferrals'] as int,
      totalRewards: (data['totalRewards'] as num).toDouble(),
    );
  }
}