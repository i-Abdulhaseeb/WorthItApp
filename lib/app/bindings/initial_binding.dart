import 'package:get/get.dart';
import '../../features/decisions/controllers/decisions_controller.dart';
import '../../features/home/controllers/home_controller.dart';
import '../../features/insights/controllers/insights_controller.dart';
import '../../features/settings/controllers/settings_controller.dart';

/// Global initial bindings for services and core dependencies
class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(() => HomeController(), fenix: true);
    Get.lazyPut<DecisionsController>(() => DecisionsController(), fenix: true);
    Get.lazyPut<InsightsController>(() => InsightsController(), fenix: true);
    Get.lazyPut<SettingsController>(() => SettingsController(), fenix: true);
  }
}
