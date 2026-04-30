class TwoFactorModel {
  String? secret;
  String? qrCodeUrl;
  List<String>? backupCodes;

  TwoFactorModel({this.secret, this.qrCodeUrl, this.backupCodes});

  TwoFactorModel.fromJson(Map<String, dynamic> json) {
    secret = json['secret'];
    qrCodeUrl = json['qrCodeUrl'];
    backupCodes = json['backupCodes'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['secret'] = secret;
    data['qrCodeUrl'] = qrCodeUrl;
    data['backupCodes'] = backupCodes;
    return data;
  }
}
