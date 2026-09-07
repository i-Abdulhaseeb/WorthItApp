import 'package:flutter/material.dart';

/// Single item tile in the decisions list
class DecisionTile extends StatelessWidget {
  final String title;
  final String verdict;
  final VoidCallback? onTap;

  const DecisionTile({
    super.key,
    required this.title,
    required this.verdict,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      trailing: Text(verdict),
      onTap: onTap,
    );
  }
}
