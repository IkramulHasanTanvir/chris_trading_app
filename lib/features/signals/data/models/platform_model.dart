class PlatformModel {
  final String value;
  final String label;

  const PlatformModel({required this.value, required this.label});

  factory PlatformModel.fromJson(Map<String, dynamic> json) {
    return PlatformModel(
      value: json['value']?.toString() ?? '',
      label: json['label']?.toString() ?? json['value']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() => {'value': value, 'label': label};
}
