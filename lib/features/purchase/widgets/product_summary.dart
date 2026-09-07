import 'package:flutter/material.dart';

/// Summary card displaying product info before review
class ProductSummary extends StatelessWidget {
  final String name;
  final double price;

  const ProductSummary({
    super.key,
    required this.name,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(name),
        trailing: Text('\$${price.toStringAsFixed(2)}'),
      ),
    );
  }
}
