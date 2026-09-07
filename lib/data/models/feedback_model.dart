/// Model representing post-decision or post-purchase feedback
class FeedbackModel {
  final String id;
  final String decisionId;
  final int rating;
  final String? comment;
  final DateTime createdAt;

  const FeedbackModel({
    required this.id,
    required this.decisionId,
    required this.rating,
    this.comment,
    required this.createdAt,
  });

  factory FeedbackModel.fromJson(Map<String, dynamic> json) {
    return FeedbackModel(
      id: json['id'] as String? ?? '',
      decisionId: json['decisionId'] as String? ?? '',
      rating: json['rating'] as int? ?? 5,
      comment: json['comment'] as String?,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'decisionId': decisionId,
        'rating': rating,
        'comment': comment,
        'createdAt': createdAt.toIso8601String(),
      };
}
