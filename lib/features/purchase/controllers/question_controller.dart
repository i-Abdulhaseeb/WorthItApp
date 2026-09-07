import 'package:get/get.dart';
import '../../../data/models/question_model.dart';

/// Controller managing dynamic questionnaire steps
class QuestionController extends GetxController {
  final currentQuestionIndex = 0.obs;
  final questions = <QuestionModel>[].obs;
  final answers = <String, dynamic>{}.obs;
}
