class PricingPlan {
  final String id;
  final double price;
  final String? badgeText;
  final double? discount;
  final String subText;



  const PricingPlan( {
    required this.id,
    required this.price,
     this.badgeText,
    required this.subText,
    this.discount,
  });

   String get formatedPrice => '\$${price.toStringAsFixed(2)}';
   String get formatedDiscount => "Save \$${discount?.toStringAsFixed(2) ?? ''}";



  static List<PricingPlan> get allPlans => [
    PricingPlan(
      id: 'monthly',
      price: 49.00,
      badgeText: '+50% affiliate bonus',
      subText: 'Billed Monthly',
    ),
    PricingPlan(
      id: 'yearly',
      price: 500.00,
      discount: 4.00,
      subText: 'Free 1 Week Trial',
    ),
  ];


  static List<String> planPolicy = [
    'Over 300 Copilot Users per day',
    'Unlock more trading options',
    'Pro support form our team',
    'Get instant notifications',
  ];
}
