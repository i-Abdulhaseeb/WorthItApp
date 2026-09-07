import 'package:flutter/material.dart';

/// Decision distribution chart placeholder
class DecisionChart extends StatelessWidget {
  const DecisionChart({super.key});

  @override
  Widget build(BuildContext context) {
    return const Card(
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(24.0),
          child: Text('Decision Chart'),
        ),
      ),
    );
  }
}
