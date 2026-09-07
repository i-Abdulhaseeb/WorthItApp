import 'package:flutter/material.dart';

/// Product title, price, category input card widget
class ProductInputCard extends StatelessWidget {
  const ProductInputCard({super.key});

  @override
  Widget build(BuildContext context) {
    return const Card(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Text('Product Input Card'),
      ),
    );
  }
}
