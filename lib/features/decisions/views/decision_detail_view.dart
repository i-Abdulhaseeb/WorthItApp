import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/decisions_controller.dart';

/// Single decision detail view
class DecisionDetailView extends GetView<DecisionsController> {
  const DecisionDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Decision Detail View'),
      ),
    );
  }
}
