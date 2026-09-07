import 'package:flutter/material.dart';

/// Selectable question option card widget
class QuestionOptionCard extends StatelessWidget {
  final String text;
  final bool isSelected;
  final VoidCallback? onTap;

  const QuestionOptionCard({
    super.key,
    required this.text,
    this.isSelected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(text),
        trailing: isSelected ? const Icon(Icons.check_circle) : null,
        onTap: onTap,
      ),
    );
  }
}
