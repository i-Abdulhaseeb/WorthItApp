import 'dart:async';
import 'dart:convert';

import 'package:get/get.dart';
import 'package:worthitapp/core/services/gemini_service.dart';

import '../../../app/routes/app_routes.dart';
import '../widgets/analysis_dialogs.dart';

/// Status enum for each analysis check step
enum AnalysisStepStatus { pending, inProgress, done }

/// Model representing a single analysis step
class AnalysisStepItem {
  final String title;
  final String subtitle;
  final Rx<AnalysisStepStatus> status;

  AnalysisStepItem({
    required this.title,
    required this.subtitle,
    AnalysisStepStatus initialStatus = AnalysisStepStatus.pending,
  }) : status = initialStatus.obs;
}

/// Controller handling AI evaluation, sequential checks animation, and verdict navigation check
class AnalysisController extends GetxController {
  // Observable progress percentage value (0.0 to 1.0)
  final RxDouble progress = 0.0.obs;

  // Track if response from Gemini model has been received
  final RxBool isModelResponseReceived = false.obs;

  // Track if UI sequential animation has finished all 4 steps
  final RxBool isAnimationComplete = false.obs;

  // The 4 sequential analysis steps shown in the UI
  late final List<AnalysisStepItem> steps;
  RxString verdict = "".obs;
  RxString reason = "".obs;
  RxInt affordability = 0.obs;
  RxInt necessity = 0.obs;
  RxInt value = 0.obs;
  RxInt usage = 0.obs;
  RxInt alternative = 0.obs;
  RxInt impulseRisk = 0.obs;
  RxString recommendation = "".obs;

  Timer? _animationTimer;

  int get averageScore {
    final sum =
        affordability.value +
        necessity.value +
        value.value +
        usage.value +
        alternative.value +
        impulseRisk.value;
    return (sum / 6).round();
  }

  String get verdictDisplayName {
    final v = verdict.value.toLowerCase().replaceAll('_', ' ').trim();
    if (v == 'dont buy' || v == 'dont_buy') {
      return "DON'T BUY";
    }
    if (v.isNotEmpty) {
      return v.toUpperCase();
    }
    return "WAIT";
  }

  String get whySayingTitle {
    final v = verdict.value.toLowerCase().replaceAll('_', ' ').trim();
    if (v == 'dont buy' || v == 'dont_buy') {
      return "Why we're saying don't buy";
    }
    if (v == 'buy') {
      return "Why we're saying buy";
    }
    return "Why we're saying wait";
  }

  @override
  void onInit() {
    super.onInit();

    _initializeSteps();
    _startSequentialChecks();
    testGemini();
  }

  Future<void> testGemini() async {
    try {
      final model = GeminiService();

      final String response = await model.analyzePurchase();
      final Map<String, dynamic> data = jsonDecode(response);
      verdict.value = data['verdict'] ?? 'wait';
      reason.value = data['reason'] ?? '';
      final Map<String, dynamic> scores = data['scores'] ?? {};
      affordability.value = scores['affordability'] ?? 0;
      necessity.value = scores['necessity'] ?? 0;
      value.value = scores['value'] ?? 0;
      usage.value = scores['usage'] ?? 0;
      alternative.value = scores['alternative'] ?? 0;
      impulseRisk.value = scores['impulse_risk'] ?? 0;
      recommendation.value = data['recommendation'] ?? '';
      print('================ GEMINI RESPONSE ================');
      print(verdict.value);
      print(affordability.value);
      print('=================================================');

      onModelResponseReceived();
    } catch (e, stackTrace) {
      print('================ GEMINI ERROR ===================');
      print(e);
      print(stackTrace);
      print('=================================================');
      _handleModelError(e);
    }
  }

  void _handleModelError(dynamic e) {
    _animationTimer?.cancel();
    final errorStr = e.toString().toLowerCase();

    // Check if error is quota / daily limit reached
    if (errorStr.contains('quota') ||
        errorStr.contains('daily') ||
        errorStr.contains('limit') ||
        errorStr.contains('resource_exhausted')) {
      showLimitReachedDialog();
    } else {
      // Otherwise show busy dialog (503, 429 rate limit, server busy, network, etc.)
      showBusyDialog();
    }
  }

  /// Displays the AI Busy popup dialog
  void showBusyDialog() {
    if (Get.isDialogOpen == true) {
      Get.back();
    }
    Get.dialog(
      AiBusyDialog(onTryAgain: retryAnalysis),
      barrierDismissible: false,
    );
  }

  /// Displays the Daily Limit Reached popup dialog
  void showLimitReachedDialog() {
    if (Get.isDialogOpen == true) {
      Get.back();
    }
    Get.dialog(
      LimitReachedDialog(onGotIt: navigateToHome),
      barrierDismissible: false,
    );
  }

  /// Retries AI analysis: resets animation steps, restarts progress, and calls Gemini
  void retryAnalysis() {
    if (Get.isDialogOpen == true) {
      Get.back();
    }
    _animationTimer?.cancel();
    progress.value = 0.15;
    isModelResponseReceived.value = false;
    isAnimationComplete.value = false;
    _initializeSteps();
    _startSequentialChecks();
    testGemini();
  }

  /// Navigates user back to home screen
  void navigateToHome() {
    if (Get.isDialogOpen == true) {
      Get.back();
    }
    Get.offAllNamed(AppRoutes.home);
  }

  void getToHome() {
    Get.offAllNamed(AppRoutes.home);
  }

  void _initializeSteps() {
    steps = [
      AnalysisStepItem(
        title: 'Understanding purchase',
        subtitle: "Analyzing what you're buying and why",
        initialStatus: AnalysisStepStatus.inProgress,
      ),
      AnalysisStepItem(
        title: 'Checking affordability',
        subtitle: 'Assessing impact on your budget',
        initialStatus: AnalysisStepStatus.pending,
      ),
      AnalysisStepItem(
        title: 'Comparing alternatives',
        subtitle: 'Looking at similar options and prices',
        initialStatus: AnalysisStepStatus.pending,
      ),
      AnalysisStepItem(
        title: 'Evaluating long-term value',
        subtitle: 'Considering durability, utility and future needs',
        initialStatus: AnalysisStepStatus.pending,
      ),
    ];
    // Start initial progress for step 1
    progress.value = 0.15;
  }

  /// Sequentially marks each check as done and gradually increments the progress bar
  void _startSequentialChecks() {
    int currentStep = 0;
    const stepDuration = Duration(milliseconds: 1400);

    _animationTimer = Timer.periodic(stepDuration, (timer) {
      if (currentStep < steps.length) {
        // Mark current step as done
        steps[currentStep].status.value = AnalysisStepStatus.done;

        currentStep++;

        if (currentStep < steps.length) {
          // Move to next step (in progress) and increase progress
          steps[currentStep].status.value = AnalysisStepStatus.inProgress;
          // Progress bar increases smoothly: 15% -> 50% -> 75% -> 90%
          progress.value = 0.25 * (currentStep + 1);
        } else {
          // All 4 checks are marked done, progress reaches 100%
          progress.value = 1.0;
          isAnimationComplete.value = true;
          timer.cancel();

          // Check if Gemini model response is ready to navigate
          _checkAndNavigateToVerdict();
        }
      }
    });
  }

  /// Method to call when the Gemini model response is received
  void onModelResponseReceived() {
    isModelResponseReceived.value = true;
    _animationTimer?.cancel();
    progress.value = 1.0;
    for (final step in steps) {
      step.status.value = AnalysisStepStatus.done;
    }
    isAnimationComplete.value = true;
    _checkAndNavigateToVerdict();
  }

  /// Checks if both UI animation and Gemini model response are ready before navigating
  void _checkAndNavigateToVerdict() {
    if (isModelResponseReceived.value) {
      Get.offNamed(AppRoutes.verdict);
    }
  }

  @override
  void onClose() {
    _animationTimer?.cancel();
    super.onClose();
  }
}
