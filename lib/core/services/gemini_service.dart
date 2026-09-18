import 'dart:convert';

import 'package:firebase_ai/firebase_ai.dart';
import 'package:get/get.dart';
import 'package:worthitapp/core/question_engine/answer_interpretation.dart';
import 'package:worthitapp/features/purchase/controllers/purchase_controller.dart';
import 'package:worthitapp/features/purchase/controllers/question_controller.dart';
import 'package:worthitapp/features/settings/controllers/settings_controller.dart';

class GeminiService {
  late final GenerativeModel _generativeModel;

  // Check that ensures response from model has been received
  bool isResponseReceived = false;

  GeminiService() {
    _generativeModel = FirebaseAI.googleAI().generativeModel(
      model: 'gemini-3.6-flash',
      generationConfig: GenerationConfig(
        temperature: 0.2,
        responseMimeType: 'application/json',
        responseSchema: Schema.object(
          properties: {
            'verdict': Schema.enumString(
              enumValues: ['buy', 'wait', 'dont_buy'],
            ),
            'reason': Schema.string(),
            'scores': Schema.object(
              properties: {
                'affordability': Schema.integer(),
                'necessity': Schema.integer(),
                'value': Schema.integer(),
                'usage': Schema.integer(),
                'alternative': Schema.integer(),
                'impulse_risk': Schema.integer(),
              },
              optionalProperties: [],
            ),
            'recommendation': Schema.string(),
          },
          optionalProperties: [],
        ),
      ),
    );
  }

  Future<String> analyzePurchase({
    PurchaseController? purchaseController,
    QuestionController? questionController,
  }) async {
    final purchaseCtrl = purchaseController ?? Get.find<PurchaseController>();
    final questionCtrl =
        questionController ??
        (Get.isRegistered<QuestionController>()
            ? Get.find<QuestionController>()
            : purchaseCtrl.questionController);
    final settingsCtrl = Get.find<SettingsController>();
    final String currencyCode = settingsCtrl.selectedCurrencyCode.value;

    final String rawIncome = settingsCtrl.income.value.replaceAll(
      RegExp(r'[^0-9.]'),
      '',
    );

    final num monthlyIncome = num.tryParse(rawIncome) ?? 0;

    final String rawWorkingHours = settingsCtrl.workingHours.value.replaceAll(
      RegExp(r'[^0-9]'),
      '',
    );

    final int workingHoursPerWeek = int.tryParse(rawWorkingHours) ?? 0;
    final String productName = purchaseCtrl.productName.value;
    final String productLink = purchaseCtrl.productLink.value;
    final String rawPrice = purchaseCtrl.productPrice.value.replaceAll(
      RegExp(r'[^0-9.]'),
      '',
    );
    final num productPrice = num.tryParse(rawPrice) ?? 0;

    final List<Map<String, dynamic>> answersList = [];
    const questionIds = [
      'motivation',
      'already_own_similar',
      'usage_frequency',
      'cheaper_alternative',
      'how_long_wanted',
      'financial_impact',
    ];

    for (final qId in questionIds) {
      final optionId =
          questionCtrl.answerFor(qId)?.selectedOptionId ??
          questionCtrl.selectedOptionByQuestion[qId];

      if (optionId != null) {
        final interpretation =
            interpretAnswer(questionId: qId, optionId: optionId) ?? '';

        answersList.add({
          'question_id': qId,
          'option_id': optionId,
          'interpretation': interpretation,
        });
      }
    }

    final prompt = buildPrompt(
      productName: productName,
      productPrice: productPrice,
      productLink: productLink,
      monthlyIncome: monthlyIncome,
      currencyCode: currencyCode,
      workingHoursPerWeek: workingHoursPerWeek,
      answers: answersList,
    );

    final response = await _generativeModel.generateContent([
      Content.text(prompt),
    ]);

    isResponseReceived = true;

    return response.text ?? "";
  }

  String buildPrompt({
    required String productName,
    required num productPrice,
    required String productLink,
    required num monthlyIncome,
    required String currencyCode,
    required int workingHoursPerWeek,
    required List<Map<String, dynamic>> answers,
  }) {
    final purchaseDataJson = const JsonEncoder.withIndent('  ').convert({
      'product': {
        'name': productName,
        'price': productPrice,
        'currency': currencyCode,
        'link': productLink,
      },
      'user': {
        'monthly_income': monthlyIncome,
        'currency': currencyCode,
        'working_hours_per_week': workingHoursPerWeek,
      },
      'answers': answers,
    });

    return '''You are the decision engine for WorthIt, a purchase decision app.

Analyze the purchase and user information provided below and produce a concise purchase decision.

DECISION RULES:

- Choose exactly one verdict: "buy", "wait", or "dont_buy".

- "buy" means the purchase is reasonably justified based on affordability, necessity, value, usage, alternatives, and impulse risk.

- "wait" means the purchase may be worthwhile but the user should delay the decision, save more, compare alternatives, or reassess their need.

- "dont_buy" means the purchase is not sufficiently justified given the user's circumstances.

- Scores must be integers from 0 to 100.

- affordability: 0 means extremely difficult to afford; 100 means comfortably affordable.

- necessity: 0 means unnecessary; 100 means essential or highly necessary.

- value: 0 means very poor value for the price; 100 means excellent value.

- usage: 0 means almost no expected use; 100 means very frequent use.

- alternative: 0 means a cheaper alternative clearly provides similar value; 100 means there is no meaningful cheaper alternative.

- impulse_risk: 0 means very low impulse risk; 100 means very high impulse risk.

- Consider the product price relative to monthly income when evaluating affordability.

- Existing ownership should reduce necessity when the current product already adequately solves the problem.

- Frequent expected usage should increase usage and potentially value, but frequent usage alone does not justify an unaffordable purchase.

- Cheaper alternatives should negatively affect the decision when they can reasonably satisfy the same need.

- A long-standing desire should generally indicate lower impulse risk than a recent desire.

- Do not assume facts that are not provided.

- Do not invent financial obligations, savings, or product features.

- Do not make the decision based on a single factor. Consider all provided information together.

WRITING RULES:

- Give a detailed, specific, and honest reason for the verdict. Clearly explain the strongest factors supporting the decision as well as any meaningful factors working against it. Do not soften or hide negative factors. The reason should help the user understand why the verdict was reached rather than simply restating the verdict.

- Give a detailed, honest, and actionable final recommendation. Clearly tell the user what they should do next and why. If the verdict is "wait" or "dont_buy", explain what would need to change for the purchase to become more reasonable. If the verdict is "buy", mention any important limitation or trade-off the user should still keep in mind.

- Use plain, direct language.

- No motivational language.

- No generic AI phrases.

- No unnecessary explanation.

- No phrases such as "based on the information provided", "it is important to consider", "as an AI", or similar filler.

- Do not repeat the user's information unnecessarily.

- Return only the requested JSON object.

PURCHASE DATA:

$purchaseDataJson

TASK:

Evaluate the purchase using all of the information above and return:

1. One verdict: buy, wait, or dont_buy.

2. One concise reason explaining the main factors behind the verdict.

3. Six scores: affordability, necessity, value, usage, alternative, and impulse_risk.

4. One concise final recommendation telling the user what to do.''';
  }
}
