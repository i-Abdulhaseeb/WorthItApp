/// Model representing a purchase evaluation request
class PurchaseModel {
  final String id;
  final String title;
  final double price;
  final String category;
  final String? imageUrl;
  final DateTime createdAt;

  const PurchaseModel({
    required this.id,
    required this.title,
    required this.price,
    required this.category,
    this.imageUrl,
    required this.createdAt,
  });

  factory PurchaseModel.fromJson(Map<String, dynamic> json) {
    return PurchaseModel(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      category: json['category'] as String? ?? '',
      imageUrl: json['imageUrl'] as String?,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'price': price,
        'category': category,
        'imageUrl': imageUrl,
        'createdAt': createdAt.toIso8601String(),
      };
}
