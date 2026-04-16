class UserResponseModel {
  final String id;
  final String name;
  final String email;
  final String role;
  final String accountStatus;
  final bool isVerified;
  final String userProfileUrl;
  final String subscriptionStatus;
  final String subscriptionTier;
  final bool twoFactorEnabled;
  final String createdAt;

  UserResponseModel({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.accountStatus,
    required this.isVerified,
    required this.userProfileUrl,
    required this.subscriptionStatus,
    required this.subscriptionTier,
    required this.twoFactorEnabled,
    required this.createdAt,
  });

  factory UserResponseModel.fromJson(Map<String, dynamic> json) {
    return UserResponseModel(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      role: json['role'] ?? 'USER',
      accountStatus: json['accountStatus'] ?? 'ACTIVE',
      isVerified: json['isVerified'] ?? false,
      userProfileUrl: json['userProfileUrl'] ?? '',
      subscriptionStatus: json['subscriptionStatus'] ?? 'none',
      subscriptionTier: json['subscriptionTier'] ?? 'free',
      twoFactorEnabled: json['twoFactorEnabled'] ?? false,
      createdAt: json['createdAt'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    '_id': id,
    'name': name,
    'email': email,
    'role': role,
    'accountStatus': accountStatus,
    'isVerified': isVerified,
    'userProfileUrl': userProfileUrl,
    'subscriptionStatus': subscriptionStatus,
    'subscriptionTier': subscriptionTier,
    'twoFactorEnabled': twoFactorEnabled,
    'createdAt': createdAt,
  };
}