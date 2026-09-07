import '../../data/models/question_model.dart';

/// Predefined question templates
class QuestionTemplates {
  List<QuestionModel> get defaultQuestions => const [
        QuestionModel(
          id: 'q1',
          prompt: 'Do you already own something similar?',
          type: 'single_choice',
          options: ['Yes', 'No', 'Not sure'],
        ),
        QuestionModel(
          id: 'q2',
          prompt: 'How often will you use this product?',
          type: 'single_choice',
          options: ['Daily', 'Weekly', 'Rarely'],
        ),
      ];
}
