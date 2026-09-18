import 'package:hive/hive.dart';

part 'hive_service.g.dart';

@HiveType(typeId: 0)
class SavedDecision extends HiveObject {
  @HiveField(0)
  final String productName;

  @HiveField(1)
  final double productPrice;

  @HiveField(2)
  final String? imagePath;

  @HiveField(3)
  final DateTime decidedAt;

  @HiveField(4)
  final String verdict;

  @HiveField(5)
  final String reason;

  @HiveField(6)
  final String recommendation;

  @HiveField(7)
  final int affordability;

  @HiveField(8)
  final int necessity;

  @HiveField(9)
  final int value;

  @HiveField(10)
  final int usage;

  @HiveField(11)
  final int alternative;

  @HiveField(12)
  final int impulseRisk;

  SavedDecision({
    required this.productName,
    required this.productPrice,
    this.imagePath,
    required this.decidedAt,
    required this.verdict,
    required this.reason,
    required this.recommendation,
    required this.affordability,
    required this.necessity,
    required this.value,
    required this.usage,
    required this.alternative,
    required this.impulseRisk,
  });
}
