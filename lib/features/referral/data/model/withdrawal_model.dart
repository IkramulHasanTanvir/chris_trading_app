class WithdrawalModel {
  final String sId;
  final String userId;
  final int amount;
  final String paymentMethod;
  final String paymentDetails;
  final String status;
  final String adminNote;
  final DateTime createdAt;
  final DateTime updatedAt;

  const WithdrawalModel({
    required this.sId,
    required this.userId,
    required this.amount,
    required this.paymentMethod,
    required this.paymentDetails,
    required this.status,
    required this.adminNote,
    required this.createdAt,
    required this.updatedAt,
  });

  factory WithdrawalModel.fromJson(Map<String, dynamic> json) {
    return WithdrawalModel(
      sId: json['_id'] as String? ?? '',
      userId: json['userId'] as String? ?? '',
      amount: json['amount'] as int? ?? 0,
      paymentMethod: json['paymentMethod'] as String? ?? '',
      paymentDetails: json['paymentDetails'] as String? ?? '',
      status: json['status'] as String? ?? '',
      adminNote: json['adminNote'] as String? ?? '',
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'] as String) ?? DateTime.now()
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'] as String) ?? DateTime.now()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': sId,
      'userId': userId,
      'amount': amount,
      'paymentMethod': paymentMethod,
      'paymentDetails': paymentDetails,
      'status': status,
      'adminNote': adminNote,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  WithdrawalModel copyWith({
    String? sId,
    String? userId,
    int? amount,
    String? paymentMethod,
    String? paymentDetails,
    String? status,
    String? adminNote,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return WithdrawalModel(
      sId: sId ?? this.sId,
      userId: userId ?? this.userId,
      amount: amount ?? this.amount,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      paymentDetails: paymentDetails ?? this.paymentDetails,
      status: status ?? this.status,
      adminNote: adminNote ?? this.adminNote,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
