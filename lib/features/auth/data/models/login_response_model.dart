
class LoginResponseModel {
  final String accessToken;
  final String refreshToken;
  final String role;
  final bool requiresTwoFactor;

  LoginResponseModel({
    required this.accessToken,
    required this.refreshToken,
    required this.role,
    required this.requiresTwoFactor,
  });

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
      accessToken: json['accessToken'] ?? '',
      refreshToken: json['refreshToken'] ?? '',
      role: json['role'] ?? 'USER',
      requiresTwoFactor: json['requiresTwoFactor'] ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
    'accessToken': accessToken,
    'refreshToken': refreshToken,
    'role': role,
    'requiresTwoFactor': requiresTwoFactor,
  };
}