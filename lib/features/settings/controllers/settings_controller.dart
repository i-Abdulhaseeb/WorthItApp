import 'package:get/get.dart';

/// Controller for Settings and preferences
class SettingsController extends GetxController {
  final userName = 'Alex Mercer'.obs;
  final currency = 'USD (\$)'.obs;
  final income = '\$6,200 / mo'.obs;
  final workingHours = '40h / week'.obs;
  final appVersion = 'v1.2.0'.obs;

  final selectedCurrencyCode = 'USD'.obs;

  void updateName(String newName) {
    if (newName.trim().isNotEmpty) {
      userName.value = newName.trim();
    }
  }

  void updateCurrency(String code, String symbol, String displayName) {
    selectedCurrencyCode.value = code;
    currency.value = '$code ($symbol)';
  }

  void updateIncome(String formattedIncome) {
    if (formattedIncome.trim().isNotEmpty) {
      income.value = formattedIncome.trim();
    }
  }

  void updateWorkingHours(int hours) {
    workingHours.value = '${hours}h / week';
  }
}


