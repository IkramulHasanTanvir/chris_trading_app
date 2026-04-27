class ContributorModel {
  final String id;
  final int totalPoints;
  final int activityCount;
  final String lastActivity;
  final List<String> activities;
  final String accountId;
  final String name;
  final String userProfileUrl;
  final String role;
  final String contributionType;

  ContributorModel({
    required this.id,
    required this.totalPoints,
    required this.activityCount,
    required this.lastActivity,
    required this.activities,
    required this.accountId,
    required this.name,
    required this.userProfileUrl,
    required this.role,
    required this.contributionType,
  });

  factory ContributorModel.fromJson(Map<String, dynamic> json) {
    return ContributorModel(
      id: json['_id'] ?? '',
      totalPoints: json['totalPoints'] ?? 0,
      activityCount: json['activityCount'] ?? 0,
      lastActivity: json['lastActivity'] ?? '',
      activities: List<String>.from(json['activities'] ?? []),
      accountId: json['accountId'] ?? '',
      name: json['name'] ?? '',
      userProfileUrl: json['userProfileUrl'] ?? '',
      role: json['role'] ?? '',
      contributionType: json['contributionType'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'totalPoints': totalPoints,
      'activityCount': activityCount,
      'lastActivity': lastActivity,
      'activities': activities,
      'accountId': accountId,
      'name': name,
      'userProfileUrl': userProfileUrl,
      'role': role,
      'contributionType': contributionType,
    };
  }
}
