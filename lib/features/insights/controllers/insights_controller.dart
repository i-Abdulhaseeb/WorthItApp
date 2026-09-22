import 'package:get/get.dart';
import 'package:worthitapp/data/models/saved_decision_model.dart';
import 'package:worthitapp/features/home/controllers/home_controller.dart';

class InsightsController extends GetxController {
  final HomeController homeController = Get.find<HomeController>();

  final String currencyLabel = 'Rs.';

  RxList<SavedDecisionModel> get savedLists => homeController.savedLists;

  List<SavedDecisionModel> get monthlyDecisions {
    final now = DateTime.now();

    return savedLists.where((decision) {
      final date = decision.decidedAt.toLocal();

      return date.year == now.year && date.month == now.month;
    }).toList();
  }

  String normalizeVerdict(String verdict) => verdict.trim().toLowerCase();

  int get totalDecisions => monthlyDecisions.length;

  int _countVerdict(String verdict) {
    return monthlyDecisions
        .where((decision) => normalizeVerdict(decision.verdict) == verdict)
        .length;
  }

  int get buyCount => _countVerdict('buy');

  int get waitCount => _countVerdict('wait');

  int get dontBuyCount => _countVerdict('dont_buy');

  int get delayedRejectedCount => waitCount + dontBuyCount;

  double get delayedRejectedPercentage {
    final total = totalDecisions;

    return total == 0 ? 0 : delayedRejectedCount / total * 100;
  }

  double get buyPercentage {
    final total = totalDecisions;

    return total == 0 ? 0 : buyCount / total * 100;
  }

  double? parsePrice(String rawPrice) {
    final cleaned = rawPrice
        .replaceAll(RegExp(r'[^0-9.,\-]'), '')
        .replaceAll(',', '');

    final value = double.tryParse(cleaned);

    if (value == null || !value.isFinite || value < 0) {
      return null;
    }

    return value;
  }

  double get avoidedAmount {
    var total = 0.0;

    for (final decision in monthlyDecisions) {
      final verdict = normalizeVerdict(decision.verdict);

      if (verdict == 'wait' || verdict == 'dont_buy') {
        total += parsePrice(decision.productPrice) ?? 0;
      }
    }

    return total;
  }

  String formatAmount(double amount) {
    final parts = amount.toStringAsFixed(2).split('.');

    final whole = parts.first.replaceAllMapped(
      RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
      (match) => '${match[1]},',
    );

    final decimals = parts[1] == '00' ? '' : '.${parts[1]}';

    return '$currencyLabel $whole$decimals';
  }

  String get formattedAvoidedAmount => formatAmount(avoidedAmount);
}
