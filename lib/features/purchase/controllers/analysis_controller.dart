import 'dart:async';
import 'package:get/get.dart';
import '../../../app/routes/app_routes.dart';

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

  Timer? _animationTimer;

  @override
  void onInit() {
    super.onInit();
    _initializeSteps();
    _startSequentialChecks();
  }

  /// Initialize the 4 checklist steps with initial states
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
    _checkAndNavigateToVerdict();
  }

  /// Checks if both UI animation and Gemini model response are ready before navigating
  void _checkAndNavigateToVerdict() {
    if (isAnimationComplete.value && isModelResponseReceived.value) {
      // =======================================================================
      // NAVIGATION TO VERDICT SCREEN:
      // =======================================================================
      // When you are ready to navigate to the verdict screen after receiving the
      // model response, perform navigation here:
      //
      // Get.offNamed(AppRoutes.verdict);
      // =======================================================================
    }
  }

  @override
  void onClose() {
    _animationTimer?.cancel();
    super.onClose();
  }
}

