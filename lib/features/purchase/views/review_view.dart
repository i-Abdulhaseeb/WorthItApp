import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/purchase_controller.dart';

/// Pre-analysis review view
class ReviewView extends GetView<PurchaseController> {
  const ReviewView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Review View'),
      ),
    );
  }
}
