import 'dart:convert';
import 'package:firebase_ai/firebase_ai.dart';
import 'package:get/get.dart';
import 'package:worthitapp/core/question_engine/answer_interpretation.dart';
import 'package:worthitapp/features/purchase/controllers/purchase_controller.dart';
import 'package:worthitapp/features/purchase/controllers/question_controller.dart';

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

  /// Sends the prompt to Gemini and returns the JSON decision response
  Future<String> analyzePurchase({
    PurchaseController? purchaseController,
    QuestionController? questionController,
  }) async {
    // 1. Get PurchaseController & QuestionController
    final purchaseCtrl = purchaseController ?? Get.find<PurchaseController>();
    final questionCtrl =
        questionController ??
        (Get.isRegistered<QuestionController>()
            ? Get.find<QuestionController>()
            : purchaseCtrl.questionController);

    // 2. Extract product details from PurchaseController
    final String productName = purchaseCtrl.productName.value;
    final String productLink = purchaseCtrl.productLink.value;
    final String rawPrice = purchaseCtrl.productPrice.value.replaceAll(
      RegExp(r'[^0-9.]'),
      '',
    );
    final num productPrice = num.tryParse(rawPrice) ?? 0;

    // 3. Tally user answers against their interpretations
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

    // 4. Build prompt
    final prompt = buildPrompt(
      productName: productName,
      productPrice: productPrice,
      productLink: productLink,
      answers: answersList,
    );

    // 5. Generate content with the model
    final response = await _generativeModel.generateContent([
      Content.text(prompt),
    ]);

    // 6. Mark check that response has been received
    isResponseReceived = true;

    return response.text ?? "";
  }

  /// Builds the complete prompt string with formatted PURCHASE DATA
  String buildPrompt({
    required String productName,
    required num productPrice,
    required String productLink,
    required List<Map<String, dynamic>> answers,
  }) {
    final purchaseDataJson = const JsonEncoder.withIndent('  ').convert({
      'product': {
        'name': productName,
        'price': productPrice,
        'currency': 'PKR',
        'link': productLink,
      },
      'user': {
        'monthly_income': 120000,
        'currency': 'PKR',
        'working_hours_per_week': 40,
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
- Keep the reason concise and specific.
- Keep the final recommendation concise and actionable.
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


