import 'package:flutter/material.dart';

/// Verdict card widget displaying final recommendation
class VerdictCard extends StatelessWidget {
  final String verdict;
  final String reasoning;

  const VerdictCard({
    super.key,
    required this.verdict,
    required this.reasoning,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Verdict: $verdict', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(reasoning),
          ],
        ),
      ),
    );
  }
}
