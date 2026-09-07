import 'package:get/get.dart';

import '../../../app/routes/app_routes.dart';

/// Controller for managing splash screen lifecycle and navigation.
class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    _navigateToHome();
  }

  /// Waits for 3 seconds and then navigates to the Home screen.
  Future<void> _navigateToHome() async {
    await Future.delayed(const Duration(seconds: 3));
    Get.offNamed(AppRoutes.home);
  }
}
