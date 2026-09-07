import 'package:get/get.dart';
import '../../../data/models/ai_decision_model.dart';

/// Controller for Decisions history list
class DecisionsController extends GetxController {
  final decisions = <AiDecisionModel>[].obs;
  final filter = 'ALL'.obs;
}
