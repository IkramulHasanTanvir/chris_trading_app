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
    return ReferralData(
      referralCode: json['referralCode'] as String,
      referralLink: json['referralLink'] as String,
      totalReferrals: json['totalReferrals'] as int,
      activeReferrals: json['activeReferrals'] as int,
      totalRewards: (json['totalRewards'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['referralCode'] = referralCode;
    data['referralLink'] = referralLink;
    data['totalReferrals'] = totalReferrals;
    data['activeReferrals'] = activeReferrals;
    data['totalRewards'] = totalRewards;
    return data;
  }
}
