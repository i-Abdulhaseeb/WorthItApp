/// Model representing a user's answer to a question
class AnswerModel {
  final String questionId;
  final dynamic selectedValue;

  const AnswerModel({
    required this.questionId,
    required this.selectedValue,
  });

  factory AnswerModel.fromJson(Map<String, dynamic> json) {
    return AnswerModel(
      questionId: json['questionId'] as String? ?? '',
      selectedValue: json['selectedValue'],
    );
  }

  Map<String, dynamic> toJson() => {
        'questionId': questionId,
        'selectedValue': selectedValue,
      };
}
