import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/decisions_controller.dart';

/// Decisions history view
class DecisionsView extends GetView<DecisionsController> {
  const DecisionsView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Decisions View'),
      ),
    );
  }
}
