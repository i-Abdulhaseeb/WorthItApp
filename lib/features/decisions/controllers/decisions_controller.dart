import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:worthitapp/data/models/saved_decision_model.dart';
import 'package:worthitapp/features/home/controllers/home_controller.dart';

class DecisionSection {
  const DecisionSection({required this.title, required this.decisions});

  final String title;
  final List<SavedDecisionModel> decisions;
}

class DecisionsController extends GetxController {
  final HomeController homeController = Get.find<HomeController>();

  final searchController = TextEditingController();

  final RxString selectedCategory = 'All'.obs;
  final RxString searchQuery = ''.obs;
  final RxBool newestFirst = true.obs;

  final List<String> categories = const ['All', 'Bought', 'Avoided', 'Waiting'];

  RxList<SavedDecisionModel> get savedLists => homeController.savedLists;

  String normalizeVerdict(String verdict) => verdict.trim().toLowerCase();

  int get totalCount => savedLists.length;

  int countFor(String verdict) {
    return savedLists
        .where((item) => normalizeVerdict(item.verdict) == verdict)
        .length;
  }

  String percentageFor(int count) {
    final total = totalCount;
    return total == 0 ? '0%' : '${(count / total * 100).round()}%';
  }

  List<SavedDecisionModel> get filteredDecisions {
    final category = selectedCategory.value;
    final query = searchQuery.value.trim().toLowerCase();
    final descending = newestFirst.value;

    String? requiredVerdict;

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
    }

    // Creates a separate list without changing HomeController's order.
    final results = savedLists.where((decision) {
      final matchesCategory =
          requiredVerdict == null ||
          normalizeVerdict(decision.verdict) == requiredVerdict;

      final matchesSearch =
          query.isEmpty || decision.productName.toLowerCase().contains(query);

      return matchesCategory && matchesSearch;
    }).toList();

    results.sort((a, b) {
      return descending
          ? b.decidedAt.compareTo(a.decidedAt)
          : a.decidedAt.compareTo(b.decidedAt);
    });

    return results;
  }

  List<DecisionSection> get sections {
    final now = DateTime.now();
    final monthStart = DateTime(now.year, now.month);

    final current = <SavedDecisionModel>[];
    final earlier = <SavedDecisionModel>[];

    for (final decision in filteredDecisions) {
      final date = decision.decidedAt.toLocal();

      if (date.isBefore(monthStart)) {
        earlier.add(decision);
      } else {
        current.add(decision);
      }
    }

    final groups = <DecisionSection>[
      if (current.isNotEmpty)
        DecisionSection(title: 'THIS MONTH', decisions: current),
      if (earlier.isNotEmpty)
        DecisionSection(title: 'EARLIER', decisions: earlier),
    ];

    // Oldest first also puts the Earlier section first.
    return newestFirst.value ? groups : groups.reversed.toList();
  }

  void selectCategory(String category) {
    selectedCategory.value = category;
  }

  void updateSearch(String value) {
    searchQuery.value = value;
  }

  void clearSearch() {
    searchController.clear();
    searchQuery.value = '';
  }

  void setSort(bool newest) {
    newestFirst.value = newest;
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

    final local = date.toLocal();
    return '${months[local.month - 1]} ${local.day}, ${local.year}';
  }

  void onDecisionTap(SavedDecisionModel decision) {
    // Add navigation later.
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}
