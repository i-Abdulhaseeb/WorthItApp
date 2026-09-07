import '../../data/models/question_model.dart';
import 'question_rules.dart';
import 'question_templates.dart';

/// Dynamic Question Generation & Flow Engine
class QuestionEngine {
  final QuestionRules rules = QuestionRules();
  final QuestionTemplates templates = QuestionTemplates();

  List<QuestionModel> generateQuestions({required double price, required String category}) {
    return templates.defaultQuestions;
  }
}
