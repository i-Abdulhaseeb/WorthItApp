import 'package:flutter/material.dart';

/// Question step progress bar widget (4px tall)
class QuestionProgress extends StatelessWidget {
  final double progress;

  const QuestionProgress({super.key, required this.progress});

  @override
  Widget build(BuildContext context) {
    return LinearProgressIndicator(
      value: progress,
      minHeight: 4,
    );
  }
}
