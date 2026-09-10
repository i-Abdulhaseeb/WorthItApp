import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/models/question_model.dart';

import 'package:worthitapp/core/question_engine/question_templates.dart';

/// Controller managing dynamic questionnaire steps
class QuestionController extends GetxController {
  final List<Question> steps = [
    ...requiredDecisionFlowQuestions,
    kDecisionFlowQuestions.firstWhere((q) => q.isOptional),
  ];

  final String productName = 'Sony WH-1000XM6';
  final double productPrice = 85000;
  final double monthlyIncome = 120000;
  final int workHoursPerWeek = 40;

  final currentStep = 0.obs;

  final RxMap<String, String> selectedOptionByQuestion = <String, String>{}.obs;

  final RxMap<String, String> freeTextByQuestion = <String, String>{}.obs;

  final RxMap<String, String> followUpValues = <String, String>{}.obs;

  final Map<String, TextEditingController> _textControllers = {};

  Question get currentQuestion => steps[currentStep.value];
  bool get isFirstStep => currentStep.value == 0;
  bool get isLastStep => currentStep.value == steps.length - 1;

  bool get canContinue {
    final q = currentQuestion;
    if (q.isOptional) return true;
    if (q.type == QuestionType.singleSelect) {
      return selectedOptionByQuestion.containsKey(q.id);
    }
    return true;
  }

  void selectOption(String questionId, String optionId) {
    selectedOptionByQuestion[questionId] = optionId;
  }

  void setFollowUpValue(String questionId, String fieldId, String value) {
    followUpValues['$questionId::$fieldId'] = value;
  }

  String followUpValue(String questionId, String fieldId) =>
      followUpValues['$questionId::$fieldId'] ?? '';

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

  void nextStep() {
    if (!canContinue) return;
    if (isLastStep) {
      return;
    }
    currentStep.value++;
  }

  void previousStep() {
    if (isFirstStep) {
      Get.back();
      return;
    }
    currentStep.value--;
  }

  void skipStep() {
    if (isLastStep) return;
    currentStep.value++;
  }

  @override
  void onClose() {
    for (final c in _textControllers.values) {
      c.dispose();
    }
    super.onClose();
  }
}
