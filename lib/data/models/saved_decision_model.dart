import 'package:worthitapp/core/storage/hive_service.dart';

class SavedDecisionModel {
  final String productName;
  final String productPrice;
  final String? imagePath;
  final DateTime decidedAt;

  final String verdict;
  final String reason;
  final String recommendation;

  final int affordability;
  final int necessity;
  final int value;
  final int usage;
  final int alternative;
  final int impulseRisk;

  SavedDecisionModel({
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

  factory SavedDecisionModel.fromSavedDecision(SavedDecision decision) {
    return SavedDecisionModel(
      productName: decision.productName,
      productPrice: decision.productPrice,
      imagePath: decision.imagePath,
      decidedAt: decision.decidedAt,
      verdict: decision.verdict,
      reason: decision.reason,
      recommendation: decision.recommendation,
      affordability: decision.affordability,
      necessity: decision.necessity,
      value: decision.value,
      usage: decision.usage,
      alternative: decision.alternative,
      impulseRisk: decision.impulseRisk,
    );
  }

  @override
  String toString() {
    return 'SavedDecisionModel(productName: $productName, productPrice: $productPrice, verdict: $verdict, decidedAt: $decidedAt, reason: $reason)';
  }
}
