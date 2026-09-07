import 'package:flutter/material.dart';

/// Filter chips widget for decisions
class DecisionFilter extends StatelessWidget {
  final String selectedFilter;
  final ValueChanged<String>? onFilterSelected;

  const DecisionFilter({
    super.key,
    this.selectedFilter = 'ALL',
    this.onFilterSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          FilterChip(
            label: const Text('All'),
            selected: selectedFilter == 'ALL',
            onSelected: (_) => onFilterSelected?.call('ALL'),
          ),
        ],
      ),
    );
  }
}
