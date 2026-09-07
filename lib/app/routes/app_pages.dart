import 'package:get/get.dart';
import '../../core/widget/bottom_nav_bar.dart';
import '../../features/decisions/controllers/decisions_controller.dart';
import '../../features/decisions/views/decision_detail_view.dart';
import '../../features/decisions/views/decisions_view.dart';
import '../../features/feedback/controllers/feedback_controller.dart';
import '../../features/feedback/views/feedback_view.dart';
import '../../features/home/controllers/home_controller.dart';
import '../../features/insights/controllers/insights_controller.dart';
import '../../features/insights/views/insights_view.dart';
import '../../features/purchase/controllers/analysis_controller.dart';
import '../../features/purchase/controllers/purchase_controller.dart';
import '../../features/purchase/controllers/question_controller.dart';
import '../../features/purchase/views/analyzing_view.dart';
import '../../features/purchase/views/product_details_view.dart';
import '../../features/purchase/views/questions_view.dart';
import '../../features/purchase/views/review_view.dart';
import '../../features/purchase/views/start_purchase_view.dart';
import '../../features/purchase/views/verdict_view.dart';
import '../../features/settings/controllers/settings_controller.dart';
import '../../features/settings/views/settings_view.dart';
import '../../features/splash/controllers/splash_controller.dart';
import '../../features/splash/views/splash_view.dart';
import 'app_routes.dart';

/// App routing table configuration
class AppPages {
  AppPages._();

  static const initial = AppRoutes.splash;

  static final routes = <GetPage>[
    GetPage(
      name: AppRoutes.splash,
      page: () => const SplashView(),
      binding: BindingsBuilder(() {
        Get.put<SplashController>(SplashController());
      }),
    ),
    GetPage(
      name: AppRoutes.home,
      page: () => const BottomNavBarWid(),
      binding: BindingsBuilder(() {
        Get.lazyPut<HomeController>(() => HomeController(), fenix: true);
        Get.lazyPut<DecisionsController>(() => DecisionsController(), fenix: true);
        Get.lazyPut<InsightsController>(() => InsightsController(), fenix: true);
        Get.lazyPut<SettingsController>(() => SettingsController(), fenix: true);
      }),
    ),
    GetPage(
      name: AppRoutes.startPurchase,
      page: () => const StartPurchaseView(),
      binding: BindingsBuilder(() {
        Get.lazyPut<PurchaseController>(() => PurchaseController());
      }),
    ),
    GetPage(
      name: AppRoutes.productDetails,
      page: () => const ProductDetailsView(),
      binding: BindingsBuilder(() {
        Get.lazyPut<PurchaseController>(() => PurchaseController());
      }),
    ),
    GetPage(
      name: AppRoutes.questions,
      page: () => const QuestionsView(),
      binding: BindingsBuilder(() {
        Get.lazyPut<QuestionController>(() => QuestionController());
      }),
    ),
    GetPage(
      name: AppRoutes.review,
      page: () => const ReviewView(),
      binding: BindingsBuilder(() {
        Get.lazyPut<PurchaseController>(() => PurchaseController());
      }),
    ),
    GetPage(
      name: AppRoutes.analyzing,
      page: () => const AnalyzingView(),
      binding: BindingsBuilder(() {
        Get.lazyPut<AnalysisController>(() => AnalysisController());
      }),
    ),
    GetPage(
      name: AppRoutes.verdict,
      page: () => const VerdictView(),
      binding: BindingsBuilder(() {
        Get.lazyPut<AnalysisController>(() => AnalysisController());
      }),
    ),
    GetPage(
      name: AppRoutes.decisions,
      page: () => const DecisionsView(),
      binding: BindingsBuilder(() {
        Get.lazyPut<DecisionsController>(() => DecisionsController(), fenix: true);
      }),
    ),
    GetPage(
      name: AppRoutes.decisionDetail,
      page: () => const DecisionDetailView(),
      binding: BindingsBuilder(() {
        Get.lazyPut<DecisionsController>(() => DecisionsController(), fenix: true);
      }),
    ),
    GetPage(
      name: AppRoutes.insights,
      page: () => const InsightsView(),
      binding: BindingsBuilder(() {
        Get.lazyPut<InsightsController>(() => InsightsController(), fenix: true);
      }),
    ),
    GetPage(
      name: AppRoutes.feedback,
      page: () => const FeedbackView(),
      binding: BindingsBuilder(() {
        Get.lazyPut<FeedbackController>(() => FeedbackController(), fenix: true);
      }),
    ),
    GetPage(
      name: AppRoutes.settings,
      page: () => const SettingsView(),
      binding: BindingsBuilder(() {
        Get.lazyPut<SettingsController>(() => SettingsController(), fenix: true);
      }),
    ),
  ];
}
