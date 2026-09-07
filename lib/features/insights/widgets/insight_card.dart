import 'package:flutter/material.dart';

/// Single AI insight recommendation card
class InsightCard extends StatelessWidget {
  final String title;
  final String description;

  const InsightCard({
    super.key,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 4),
            Text(description),
          ],
        ),
      ),
    );
  }
}
