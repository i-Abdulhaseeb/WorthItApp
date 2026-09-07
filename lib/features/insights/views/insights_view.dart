import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/insights_controller.dart';

/// Insights overview view
class InsightsView extends GetView<InsightsController> {
  const InsightsView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Insights View'),
      ),
    );
  }
}
