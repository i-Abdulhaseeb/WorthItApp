import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/purchase_controller.dart';

/// Product details input view
class ProductDetailsView extends GetView<PurchaseController> {
  const ProductDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Product Details View'),
      ),
    );
  }
}
