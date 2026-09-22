import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:worthitapp/app/routes/app_routes.dart';
import 'package:worthitapp/core/storage/hive_service.dart';
import 'package:worthitapp/data/models/saved_decision_model.dart';

/// Controller for Home dashboard.
class HomeController extends GetxController {
  RxString greeting = 'Good Morning'.obs;

  final RxList<SavedDecisionModel> savedLists = <SavedDecisionModel>[].obs;

  @override
  void onInit() {
    super.onInit();

    updateGreeting();

    if (savedLists.isEmpty) {
      loadDecisions();
    }
  }

  void loadDecisions() {
    final box = Hive.box<SavedDecision>('decisions');

    savedLists.assignAll(
      box.values
          .map((saved) => SavedDecisionModel.fromSavedDecision(saved))
          .toList()
          .reversed,
    );

    print('================ SAVED DECISIONS (HOME) ================');
    print('Total count: ${savedLists.length}');

    for (int i = 0; i < savedLists.length; i++) {
      print('[$i] ${savedLists[i]}');
    }

    print('========================================================');
  }

  void updateGreeting() {
    final hour = DateTime.now().hour;

    if (hour >= 6 && hour < 12) {
      greeting.value = 'Good Morning';
    } else if (hour >= 12 && hour < 19) {
      greeting.value = 'Good Afternoon';
    } else if (hour >= 19 && hour < 21) {
      greeting.value = 'Good Evening';
    } else {
      greeting.value = 'Good Night';
    }
  }

  void startDecision() {
    Get.toNamed(AppRoutes.startPurchase);
  }
}
