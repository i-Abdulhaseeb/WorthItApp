/// answer_model.dart
///
/// Defines the schema for storing user answers to the "Should I Buy It?"
/// decision-flow questions (see question_model.dart / question_templates.dart).

import 'question_model.dart';

// ---------------------------------------------------------------------------
// A single question's answer
// ---------------------------------------------------------------------------

class QuestionAnswer {
  final String questionId;
  final int step;
  final QuestionType type;

  /// For singleSelect questions: the id of the chosen QuestionOption.
  final String? selectedOptionId;

  /// For singleSelect options that revealed follow-up fields (e.g. Q4's
  /// "Yes" -> alternative name + approx price): fieldId -> raw string value.
  final Map<String, String>? followUpValues;

  /// For freeText questions: the raw text entered by the user.
  final String? freeTextValue;

  /// True if the user explicitly skipped this question
  /// ("Skip this question" / "Skip for now").
  final bool skipped;

  final DateTime answeredAt;

  const QuestionAnswer({
    required this.questionId,
    required this.step,
    required this.type,
    this.selectedOptionId,
    this.followUpValues,
    this.freeTextValue,
    this.skipped = false,
    required this.answeredAt,
  });

  /// Convenience constructor for answering a singleSelect question.
  factory QuestionAnswer.select({
    required Question question,
    required String selectedOptionId,
    Map<String, String>? followUpValues,
  }) {
    assert(question.type == QuestionType.singleSelect);
    return QuestionAnswer(
      questionId: question.id,
      step: question.step,
      type: question.type,
      selectedOptionId: selectedOptionId,
      followUpValues: followUpValues,
      answeredAt: DateTime.now(),
    );
  }

  /// Convenience constructor for answering a freeText question.
  factory QuestionAnswer.text({
    required Question question,
    required String text,
  }) {
    assert(question.type == QuestionType.freeText);
    return QuestionAnswer(
      questionId: question.id,
      step: question.step,
      type: question.type,
      freeTextValue: text,
      answeredAt: DateTime.now(),
    );
  }

  /// Convenience constructor for skipping a question.
  factory QuestionAnswer.skip(Question question) {
    return QuestionAnswer(
      questionId: question.id,
      step: question.step,
      type: question.type,
      skipped: true,
      answeredAt: DateTime.now(),
    );
  }

  bool get isAnswered =>
      !skipped &&
      (selectedOptionId != null ||
          (freeTextValue != null && freeTextValue!.trim().isNotEmpty));

  QuestionAnswer copyWith({
    String? selectedOptionId,
    Map<String, String>? followUpValues,
    String? freeTextValue,
    bool? skipped,
  }) {
    return QuestionAnswer(
      questionId: questionId,
      step: step,
      type: type,
      selectedOptionId: selectedOptionId ?? this.selectedOptionId,
      followUpValues: followUpValues ?? this.followUpValues,
      freeTextValue: freeTextValue ?? this.freeTextValue,
      skipped: skipped ?? this.skipped,
      answeredAt: DateTime.now(),
    );
  }

  factory QuestionAnswer.fromJson(Map<String, dynamic> json) {
    return QuestionAnswer(
      questionId: json['questionId'] as String,
      step: json['step'] as int,
      type: QuestionType.values.byName(json['type'] as String),
      selectedOptionId: json['selectedOptionId'] as String?,
      followUpValues: (json['followUpValues'] as Map<String, dynamic>?)?.map(
        (k, v) => MapEntry(k, v as String),
      ),
      freeTextValue: json['freeTextValue'] as String?,
      skipped: json['skipped'] as bool? ?? false,
      answeredAt: DateTime.parse(json['answeredAt'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
    'questionId': questionId,
    'step': step,
    'type': type.name,
    if (selectedOptionId != null) 'selectedOptionId': selectedOptionId,
    if (followUpValues != null) 'followUpValues': followUpValues,
    if (freeTextValue != null) 'freeTextValue': freeTextValue,
    'skipped': skipped,
    'answeredAt': answeredAt.toIso8601String(),
  };
}

// ---------------------------------------------------------------------------
// The product being considered (shown in the sticky header on every step)
// ---------------------------------------------------------------------------

class ConsideredProduct {
  final String id;
  final String name;
  final double price;
  final String currency; // e.g. "Rs."

  const ConsideredProduct({
    required this.id,
    required this.name,
    required this.price,
    this.currency = 'Rs.',
  });

  factory ConsideredProduct.fromJson(Map<String, dynamic> json) {
    return ConsideredProduct(
      id: json['id'] as String,
      name: json['name'] as String,
      price: (json['price'] as num).toDouble(),
      currency: json['currency'] as String? ?? 'Rs.',
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'price': price,
    'currency': currency,
  };
}

// ---------------------------------------------------------------------------
// The full set of answers for one decision-flow run
// ---------------------------------------------------------------------------

class DecisionFlowAnswers {
  final String flowId;
  final ConsideredProduct product;

  /// questionId -> answer
  final Map<String, QuestionAnswer> answers;

  final DateTime startedAt;
  DateTime? completedAt;

  DecisionFlowAnswers({
    required this.flowId,
    required this.product,
    Map<String, QuestionAnswer>? answers,
    DateTime? startedAt,
    this.completedAt,
  }) : answers = answers ?? {},
       startedAt = startedAt ?? DateTime.now();

  QuestionAnswer? answerFor(String questionId) => answers[questionId];

  void setAnswer(QuestionAnswer answer) {
    answers[answer.questionId] = answer;
  }

  /// Whether every required (non-optional) question in [questions] has
  /// been answered (and not skipped).
  bool isComplete(List<Question> questions) {
    for (final q in questions.where((q) => !q.isOptional)) {
      final a = answers[q.id];
      if (a == null || !a.isAnswered) return false;
    }
    return true;
  }

  void markCompleted() {
    completedAt = DateTime.now();
  }

  factory DecisionFlowAnswers.fromJson(Map<String, dynamic> json) {
    return DecisionFlowAnswers(
      flowId: json['flowId'] as String,
      product: ConsideredProduct.fromJson(
        json['product'] as Map<String, dynamic>,
      ),
      answers: (json['answers'] as Map<String, dynamic>? ?? {}).map(
        (k, v) =>
            MapEntry(k, QuestionAnswer.fromJson(v as Map<String, dynamic>)),
      ),
      startedAt: DateTime.parse(json['startedAt'] as String),
      completedAt: json['completedAt'] != null
          ? DateTime.parse(json['completedAt'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'flowId': flowId,
    'product': product.toJson(),
    'answers': answers.map((k, v) => MapEntry(k, v.toJson())),
    'startedAt': startedAt.toIso8601String(),
    if (completedAt != null) 'completedAt': completedAt!.toIso8601String(),
  };
}
