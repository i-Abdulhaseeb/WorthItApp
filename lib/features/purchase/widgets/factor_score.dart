import 'package:flutter/material.dart';

/// Factor score and evaluation breakdown widget
class FactorScore extends StatelessWidget {
  final String label;
  final double score;

  const FactorScore({
    super.key,
    required this.label,
    required this.score,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label),
        Text('${(score * 100).toInt()}%'),
      ],
    );
  }
}
