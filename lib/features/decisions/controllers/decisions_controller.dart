import 'package:get/get.dart';
import 'package:worthitapp/data/models/saved_decision_model.dart';
import 'package:worthitapp/features/home/controllers/home_controller.dart';

class DecisionsController extends GetxController {
  final HomeController homeController = Get.find<HomeController>();

  final RxString selectedCategory = 'All'.obs;

  final List<String> categories = const ['All', 'Bought', 'Avoided', 'Waiting'];

  // Uses the Home controller's existing reactive list.
  RxList<SavedDecisionModel> get savedLists => homeController.savedLists;

  List<SavedDecisionModel> get filteredDecisions {
    final category = selectedCategory.value;

    final String? requiredVerdict;

    switch (category) {
      case 'Bought':
        requiredVerdict = 'buy';
        break;
      case 'Avoided':
        requiredVerdict = 'dont_buy';
        break;
      case 'Waiting':
        requiredVerdict = 'wait';
        break;
      default:
        requiredVerdict = null;
    }

    if (requiredVerdict == null) {
      return savedLists.toList();
    }

    return savedLists
        .where(
          (decision) =>
              decision.verdict.trim().toLowerCase() == requiredVerdict,
        )
        .toList();
  }

  void selectCategory(String category) {
    selectedCategory.value = category;
  }

  String formatDate(DateTime date) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];

    final localDate = date.toLocal();

    return '${months[localDate.month - 1]} '
        '${localDate.day}, ${localDate.year}';
  }

  void onDecisionTap(SavedDecisionModel decision) {
    // Add decision-detail navigation here later.
  }
}
