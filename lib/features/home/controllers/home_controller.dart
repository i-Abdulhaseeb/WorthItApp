import 'package:get/get.dart';

/// Controller for Home dashboard
class HomeController extends GetxController {
  RxString greeting = 'Good Morning'.obs;
  RxList totalDecisions = [].obs;
  @override
  void onInit() {
    super.onInit();
    updateGreeting();
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

  void updateCount() {
    totalDecisions.add("Haseeb");
    print(totalDecisions);
  }
}
