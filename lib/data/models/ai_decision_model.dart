/// Model representing the AI evaluation result
class AiDecisionModel {
  final String id;
  final String purchaseId;
  final String verdict; // BUY, WAIT, DONT_BUY
  final double confidenceScore;
  final String reasoning;
  final List<String> factors;
  final DateTime createdAt;

  const AiDecisionModel({
    required this.id,
    required this.purchaseId,
    required this.verdict,
    required this.confidenceScore,
    required this.reasoning,
    required this.factors,
    required this.createdAt,
  });

  factory AiDecisionModel.fromJson(Map<String, dynamic> json) {
    return AiDecisionModel(
      id: json['id'] as String? ?? '',
      purchaseId: json['purchaseId'] as String? ?? '',
      verdict: json['verdict'] as String? ?? 'WAIT',
      confidenceScore: (json['confidenceScore'] as num?)?.toDouble() ?? 0.0,
      reasoning: json['reasoning'] as String? ?? '',
      factors: (json['factors'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? const [],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'purchaseId': purchaseId,
        'verdict': verdict,
        'confidenceScore': confidenceScore,
        'reasoning': reasoning,
        'factors': factors,
        'createdAt': createdAt.toIso8601String(),
      };
}
