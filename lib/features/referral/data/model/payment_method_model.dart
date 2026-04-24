import 'package:flutter_task/core/utils/assets_path/assets.gen.dart';

class PaymentMethodModel {
  final String name;
  final String iconPath;

  PaymentMethodModel({required this.name, required this.iconPath});

  static final List<PaymentMethodModel> paymentMethods = [
    PaymentMethodModel(name: 'Paypal', iconPath: Assets.icons.paypal.path),
    PaymentMethodModel(name: 'Zelle', iconPath: Assets.icons.zelle.path),
  ];
}
