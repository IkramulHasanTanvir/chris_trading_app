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


static List<ContributorModel> contributors = [
  ContributorModel(
      totalPoints: 195,
      activityCount: 19,
      lastActivity: "2026-04-21",
      activities: [
        "create_signal",
        "close_signal_profit",
      ],
      accountId: "1",
      name: "Super Master",
      userProfileUrl: "https://i.pravatar.cc/150?img=1",
      role: "MASTER",
      contributionType: "Top Creator", id: '1',
    ),
    ContributorModel(

      totalPoints: 105,
      activityCount: 10,
      lastActivity: "2026-04-24",
      activities: ["create_signal"],
      accountId: "2",
      name: "Reazul Islam",
      userProfileUrl: "https://i.pravatar.cc/150?img=1",
      role: "MASTER",
      contributionType: "Top Creator", id: '',
    ),
    ContributorModel(
      totalPoints: 80,
      activityCount: 8,
      lastActivity: "2026-04-23",
      activities: ["create_signal"],
      accountId: "3",
      name: "Rahim",
      userProfileUrl: "https://i.pravatar.cc/150?img=1",
      role: "MASTER",
      contributionType: "Top Creator", id: '',
    ),
    ContributorModel(
      totalPoints: 14,
      activityCount: 5,
      lastActivity: "2026-04-20",
      activities: ["bookmark_signal"],
      accountId: "4",
      name: "John Doe",
      userProfileUrl: "https://i.pravatar.cc/150?img=1",
      role: "USER",
      contributionType: "Curator", id: '',
    ),
  ];
}
