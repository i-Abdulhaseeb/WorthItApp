import 'package:flutter/material.dart';

/// Total spending vs savings summary card
class SpendingSummary extends StatelessWidget {
  final double spent;
  final double saved;

  const SpendingSummary({
    super.key,
    required this.spent,
    required this.saved,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text('Spent: \$${spent.toStringAsFixed(2)}'),
            Text('Saved: \$${saved.toStringAsFixed(2)}'),
          ],
        ),
      ),
    );
  }
}
