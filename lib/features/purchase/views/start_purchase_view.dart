import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/purchase_controller.dart';

/// Start Purchase View
class StartPurchaseView extends GetView<PurchaseController> {
  const StartPurchaseView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Start Purchase View'),
      ),
    );
  }
}
