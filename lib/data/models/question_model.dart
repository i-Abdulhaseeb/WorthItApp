/// Model representing a prompt or question in the decision flow
class QuestionModel {
  final String id;
  final String prompt;
  final String type;
  final List<String> options;

  const QuestionModel({
    required this.id,
    required this.prompt,
    required this.type,
    required this.options,
  });

  factory QuestionModel.fromJson(Map<String, dynamic> json) {
    return QuestionModel(
      id: json['id'] as String? ?? '',
      prompt: json['prompt'] as String? ?? '',
      type: json['type'] as String? ?? 'single_choice',
      options: (json['options'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? const [],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'prompt': prompt,
        'type': type,
        'options': options,
      };
}
