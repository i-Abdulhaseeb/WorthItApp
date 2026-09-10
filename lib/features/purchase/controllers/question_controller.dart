import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:worthitapp/features/purchase/controllers/purchase_controller.dart';

import '../../../data/models/question_model.dart';
import '../../../data/models/answer_model.dart';

import 'package:worthitapp/core/question_engine/question_templates.dart';

/// Controller managing dynamic questionnaire steps and answers.
class QuestionController extends GetxController {
  final double monthlyIncome = 120000;
  final int workHoursPerWeek = 40;
  final int hourlyRate = 8;
  final PurchaseController purchaseController = Get.find<PurchaseController>();

  // ---------------------------------------------------------------------------
  // Questions
  // ---------------------------------------------------------------------------

  final List<Question> steps = [
    ...requiredDecisionFlowQuestions,
    kDecisionFlowQuestions.firstWhere((q) => q.isOptional),
  ];

  Question get currentQuestion => steps[currentStep.value];

  // ---------------------------------------------------------------------------
  // Temporary UI state
  //
  // These values represent what the user is currently editing/selecting.
  // They are committed to DecisionFlowAnswers only when Continue is pressed.
  // ---------------------------------------------------------------------------

  final currentStep = 0.obs;

  final RxMap<String, String> selectedOptionByQuestion = <String, String>{}.obs;

  final RxMap<String, String> freeTextByQuestion = <String, String>{}.obs;

  final RxMap<String, String> followUpValues = <String, String>{}.obs;

  final Map<String, TextEditingController> _textControllers = {};

  // ---------------------------------------------------------------------------
  // Saved answers
  // ---------------------------------------------------------------------------

  late final DecisionFlowAnswers decisionAnswers;

  @override
  void onInit() {
    super.onInit();

    decisionAnswers = DecisionFlowAnswers(
      flowId: 'purchase_decision_${DateTime.now().millisecondsSinceEpoch}',
      product: ConsideredProduct(
        id: 'current_product',
        name: purchaseController.productName.value,
        price: double.parse(purchaseController.productPrice.value),
        currency: 'Rs.',
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Step helpers
  // ---------------------------------------------------------------------------

  bool get isFirstStep => currentStep.value == 0;

  bool get isLastStep => currentStep.value == steps.length - 1;

  bool get canContinue {
    final q = currentQuestion;

    // Optional free-text question can be continued
    // even when the user leaves it empty.
    if (q.isOptional) {
      return true;
    }

    if (q.type == QuestionType.singleSelect) {
      return selectedOptionByQuestion.containsKey(q.id);
    }

    return true;
  }

  // ---------------------------------------------------------------------------
  // Selection
  // ---------------------------------------------------------------------------

  void selectOption(String questionId, String optionId) {
    selectedOptionByQuestion[questionId] = optionId;

    // If the user changes the selected option, remove follow-up
    // values belonging to the old selection.
    _clearFollowUpsForQuestion(questionId);
  }

  // ---------------------------------------------------------------------------
  // Follow-up fields
  // ---------------------------------------------------------------------------

  void setFollowUpValue(String questionId, String fieldId, String value) {
    followUpValues['$questionId::$fieldId'] = value;
  }

  String followUpValue(String questionId, String fieldId) {
    return followUpValues['$questionId::$fieldId'] ?? '';
  }

  // ---------------------------------------------------------------------------
  // Free text
  // ---------------------------------------------------------------------------

  void setFreeText(String questionId, String value) {
    freeTextByQuestion[questionId] = value;
  }

  TextEditingController textControllerFor(String questionId) {
    return _textControllers.putIfAbsent(
      questionId,
      () => TextEditingController(text: freeTextByQuestion[questionId] ?? ''),
    );
  }

  void appendQuickPrompt(String questionId, String prompt) {
    final field = textControllerFor(questionId);

    final updated = field.text.isEmpty ? prompt : '${field.text} $prompt';

    field.text = updated;

    field.selection = TextSelection.collapsed(offset: updated.length);

    freeTextByQuestion[questionId] = updated;
  }

  // ---------------------------------------------------------------------------
  // SAVE CURRENT ANSWER
  // ---------------------------------------------------------------------------

  void saveCurrentAnswer() {
    final question = currentQuestion;

    // ---------------------------------------------------------
    // Single select
    // ---------------------------------------------------------
    if (question.type == QuestionType.singleSelect) {
      final selectedOptionId = selectedOptionByQuestion[question.id];

      if (selectedOptionId == null) {
        return;
      }

      final Map<String, String> questionFollowUps = {};

      for (final entry in followUpValues.entries) {
        final prefix = '${question.id}::';

        if (entry.key.startsWith(prefix)) {
          final fieldId = entry.key.substring(prefix.length);

          if (entry.value.trim().isNotEmpty) {
            questionFollowUps[fieldId] = entry.value.trim();
          }
        }
      }

      final answer = QuestionAnswer.select(
        question: question,
        selectedOptionId: selectedOptionId,
        followUpValues: questionFollowUps.isEmpty ? null : questionFollowUps,
      );

      decisionAnswers.setAnswer(answer);
      return;
    }

    // ---------------------------------------------------------
    // Free text
    // ---------------------------------------------------------
    if (question.type == QuestionType.freeText) {
      final text = freeTextByQuestion[question.id]?.trim() ?? '';

      // Optional + empty = don't save anything
      if (question.isOptional && text.isEmpty) {
        return;
      }

      // If there is text, ALWAYS save it.
      if (text.isNotEmpty) {
        final answer = QuestionAnswer.text(question: question, text: text);

        decisionAnswers.setAnswer(answer);
      }
    }

    // ---------------------------------------------------------
    // Free text
    // ---------------------------------------------------------

    if (question.type == QuestionType.freeText) {
      final text = freeTextByQuestion[question.id]?.trim() ?? '';

      // Optional question:
      // if the user didn't write anything, don't save an answer.
      if (question.isOptional && text.isEmpty) {
        return;
      }

      final answer = QuestionAnswer.text(question: question, text: text);

      decisionAnswers.setAnswer(answer);
    }
  }

  // ---------------------------------------------------------------------------
  // SKIP CURRENT QUESTION
  // ---------------------------------------------------------------------------

  void skipCurrentQuestion() {
    final question = currentQuestion;

    // Optional question:
    // User explicitly skipped it, so we don't need to store an answer.
    //
    // This means:
    // answers contains only questions the user actually answered.
    if (question.isOptional) {
      decisionAnswers.answers.remove(question.id);
    } else {
      // Required question that allows skipping:
      // store the skip explicitly.
      decisionAnswers.setAnswer(QuestionAnswer.skip(question));
    }
  }

  // ---------------------------------------------------------------------------
  // NEXT
  // ---------------------------------------------------------------------------

  void nextStep() {
    if (!canContinue) return;

    // Save the current answer first.
    saveCurrentAnswer();

    // Last question
    if (isLastStep) {
      decisionAnswers.markCompleted();

      printSavedAnswers();

      // Later:
      // Get.toNamed(AppRoutes.review);

      return;
    }

    currentStep.value++;
  }

  // ---------------------------------------------------------------------------
  // PREVIOUS
  // ---------------------------------------------------------------------------

  void previousStep() {
    if (isFirstStep) {
      Get.back();
      return;
    }

    currentStep.value--;
  }

  // ---------------------------------------------------------------------------
  // SKIP
  // ---------------------------------------------------------------------------

  void skipStep() {
    skipCurrentQuestion();

    if (isLastStep) {
      printSavedAnswers();
      decisionAnswers.markCompleted();

      // Later:
      // Get.toNamed(AppRoutes.review);

      return;
    }

    currentStep.value++;
  }

  // ---------------------------------------------------------------------------
  // GET SAVED ANSWER
  // ---------------------------------------------------------------------------

  QuestionAnswer? answerFor(String questionId) {
    return decisionAnswers.answerFor(questionId);
  }

  // ---------------------------------------------------------------------------
  // DEBUG / TESTING
  // ---------------------------------------------------------------------------

  void printSavedAnswers() {
    for (final entry in decisionAnswers.answers.entries) {
      debugPrint('Question: ${entry.key}');

      debugPrint('Selected option: ${entry.value.selectedOptionId}');

      debugPrint('Follow-ups: ${entry.value.followUpValues}');

      debugPrint('Free text: ${entry.value.freeTextValue}');

      debugPrint('Skipped: ${entry.value.skipped}');

      debugPrint('-------------------------');
    }
  }

  // ---------------------------------------------------------------------------
  // INTERNAL HELPERS
  // ---------------------------------------------------------------------------

  void _clearFollowUpsForQuestion(String questionId) {
    final prefix = '$questionId::';

    final keysToRemove = followUpValues.keys
        .where((key) => key.startsWith(prefix))
        .toList();

    for (final key in keysToRemove) {
      followUpValues.remove(key);
    }
  }

  // ---------------------------------------------------------------------------
  // Dispose
  // ---------------------------------------------------------------------------

  @override
  void onClose() {
    for (final controller in _textControllers.values) {
      controller.dispose();
    }

    super.onClose();
  }
}
