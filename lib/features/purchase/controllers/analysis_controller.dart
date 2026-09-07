import 'package:get/get.dart';
import '../../../data/models/ai_decision_model.dart';

/// Controller handling AI evaluation, reasoning and verdict
class AnalysisController extends GetxController {
  final isAnalyzing = false.obs;
  final decision = Rxn<AiDecisionModel>();
}
