class DecisionResult {
  final String verdict;
  final String reason;
  final DecisionScores scores;
  final String recommendation;

  DecisionResult({
    required this.verdict,
    required this.reason,
    required this.scores,
    required this.recommendation,
  });

  factory DecisionResult.fromJson(Map<String, dynamic> json) {
    return DecisionResult(
      verdict: json['verdict'],
      reason: json['reason'],
      scores: DecisionScores.fromJson(json['scores']),
      recommendation: json['recommendation'],
    );
  }
}

class DecisionScores {
  final int affordability;
  final int necessity;
  final int value;
  final int usage;
  final int alternative;
  final int impulseRisk;

  DecisionScores({
    required this.affordability,
    required this.necessity,
    required this.value,
    required this.usage,
    required this.alternative,
    required this.impulseRisk,
  });

  factory DecisionScores.fromJson(Map<String, dynamic> json) {
    return DecisionScores(
      affordability: json['affordability'],
      necessity: json['necessity'],
      value: json['value'],
      usage: json['usage'],
      alternative: json['alternative'],
      impulseRisk: json['impulse_risk'],
    );
  }
}
