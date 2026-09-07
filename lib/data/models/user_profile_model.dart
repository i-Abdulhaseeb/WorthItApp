/// Model representing user financial profile and settings
class UserProfileModel {
  final String id;
  final String name;
  final double monthlyBudget;
  final String currency;

  const UserProfileModel({
    required this.id,
    required this.name,
    required this.monthlyBudget,
    this.currency = '\$',
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      monthlyBudget: (json['monthlyBudget'] as num?)?.toDouble() ?? 0.0,
      currency: json['currency'] as String? ?? '\$',
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'monthlyBudget': monthlyBudget,
        'currency': currency,
      };
}
