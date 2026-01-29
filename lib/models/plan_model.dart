class SubscriptionPlanModel {
  final int planId;
  final String name;
  final String subtitle;
  final String? descr;
  final String? badge;
  final List<String> features;
  final List<PriceModel> prices;
  final Map<String, dynamic> permissions;
  final bool isActive;
  final int? activePriceId;
  final String? expiresAt;
  String? dummyImage; // Added for UI

  SubscriptionPlanModel({
    required this.planId,
    required this.name,
    required this.subtitle,
    this.descr,
    this.badge,
    required this.features,
    required this.prices,
    required this.permissions,
    required this.isActive,
    this.activePriceId,
    this.expiresAt,
  });

  factory SubscriptionPlanModel.fromJson(Map<String, dynamic> json) {
    return SubscriptionPlanModel(
      planId: json['planId'],
      name: json['name'],
      subtitle: json['subtitle'],
      descr: json['descr'],
      badge: json['badge'],
      features: List<String>.from(json['features'] ?? []),
      prices: (json['prices'] as List).map((p) => PriceModel.fromJson(p)).toList(),
      permissions: Map<String, dynamic>.from(json['permissions'] ?? {}),
      isActive: json['isActive'] ?? false,
      activePriceId: json['activePriceId'],
      expiresAt: json['expiresAt'],
    );
  }
}

class PriceModel {
  final int priceId;
  final String cycle;
  final double price;
  final double? offerPrice;
  final int? discount;
  final int days;

  PriceModel({
    required this.priceId,
    required this.cycle,
    required this.price,
    this.offerPrice,
    this.discount,
    required this.days,
  });

  factory PriceModel.fromJson(Map<String, dynamic> json) {
    return PriceModel(
      priceId: json['priceId'],
      cycle: json['cycle'] ?? "",
      price: (json['price'] as num).toDouble(),
      offerPrice: json['offerPrice'] != null ? (json['offerPrice'] as num).toDouble() : null,
      discount: json['discount'],
      days: json['days'] ?? 0,
    );
  }
}