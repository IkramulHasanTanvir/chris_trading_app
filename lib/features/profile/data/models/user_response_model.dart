class UserResponseModel {
  bool? referralCodeChanged;
  String? sId;
  String? name;
  String? email;
  bool? isDeleted;
  String? accountStatus;
  String? role;
  bool? isVerified;
  String? userProfileUrl;
  String? subscriptionStatus;
  String? subscriptionTier;
  bool? trialUsed;
  bool? twoFactorEnabled;
  int? loginAttempts;
  String? lastPasswordChange;
  String? createdAt;
  String? updatedAt;
  String? stripeCustomerId;
  String? subscriptionExpiresAt;
  String? referralCode;
  int? walletBalance;

  UserResponseModel({
    this.referralCodeChanged,
    this.sId,
    this.name,
    this.email,
    this.isDeleted,
    this.accountStatus,
    this.role,
    this.isVerified,
    this.userProfileUrl,
    this.subscriptionStatus,
    this.subscriptionTier,
    this.trialUsed,
    this.twoFactorEnabled,
    this.loginAttempts,
    this.lastPasswordChange,
    this.createdAt,
    this.updatedAt,
    this.stripeCustomerId,
    this.subscriptionExpiresAt,
    this.referralCode,
    this.walletBalance,
  });

  UserResponseModel.fromJson(Map<String, dynamic> json) {
    referralCodeChanged = json['referralCodeChanged'];
    sId = json['_id'];
    name = json['name'];
    email = json['email'];
    isDeleted = json['isDeleted'];
    accountStatus = json['accountStatus'];
    role = json['role'];
    isVerified = json['isVerified'];
    userProfileUrl = json['userProfileUrl'];
    subscriptionStatus = json['subscriptionStatus'];
    subscriptionTier = json['subscriptionTier'];
    trialUsed = json['trialUsed'];
    twoFactorEnabled = json['twoFactorEnabled'];
    loginAttempts = json['loginAttempts'];
    lastPasswordChange = json['lastPasswordChange'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    stripeCustomerId = json['stripeCustomerId'];
    subscriptionExpiresAt = json['subscriptionExpiresAt'];
    referralCode = json['referralCode'];
    walletBalance = json['walletBalance'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['referralCodeChanged'] = referralCodeChanged;
    data['_id'] = sId;
    data['name'] = name;
    data['email'] = email;
    data['isDeleted'] = isDeleted;
    data['accountStatus'] = accountStatus;
    data['role'] = role;
    data['isVerified'] = isVerified;
    data['userProfileUrl'] = userProfileUrl;
    data['subscriptionStatus'] = subscriptionStatus;
    data['subscriptionTier'] = subscriptionTier;
    data['trialUsed'] = trialUsed;
    data['twoFactorEnabled'] = twoFactorEnabled;
    data['loginAttempts'] = loginAttempts;
    data['lastPasswordChange'] = lastPasswordChange;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['stripeCustomerId'] = stripeCustomerId;
    data['subscriptionExpiresAt'] = subscriptionExpiresAt;
    data['referralCode'] = referralCode;
    data['walletBalance'] = walletBalance;
    return data;
  }
}
