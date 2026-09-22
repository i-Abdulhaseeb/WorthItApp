import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:worthitapp/data/models/saved_decision_model.dart';

import '../controllers/decisions_controller.dart';

class DecisionsView extends GetView<DecisionsController> {
  const DecisionsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Your decisions'),
      ),
      body: SafeArea(
        top: false,
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),

            // Category filters.
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Obx(() {
                final selected = controller.selectedCategory.value;

                return Row(
                  children: controller.categories.map((category) {
                    return Padding(
                      padding: EdgeInsets.only(
                        right: category == controller.categories.last ? 0 : 10,
                      ),
                      child: _CategoryChip(
                        label: category,
                        selected: selected == category,
                        onTap: () => controller.selectCategory(category),
                      ),
                    );
                  }).toList(),
                );
              }),
            ),

            const SizedBox(height: 28),

            Expanded(
              child: Obx(() {
                final decisions = controller.filteredDecisions;

                if (decisions.isEmpty) {
                  return _EmptyDecisions(
                    category: controller.selectedCategory.value,
                  );
                }

                return ListView.separated(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                  itemCount: decisions.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final decision = decisions[index];

                    return _DecisionTile(
                      decision: decision,
                      dateLabel: controller.formatDate(decision.decidedAt),
                      onTap: () => controller.onDecisionTap(decision),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  const _CategoryChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Semantics(
      button: true,
      selected: selected,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(24),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeOut,
            constraints: const BoxConstraints(minHeight: 44),
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
            decoration: BoxDecoration(
              color: selected ? colors.inverseSurface : colors.surface,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: selected ? colors.inverseSurface : colors.outlineVariant,
                width: 1,
              ),
              boxShadow: selected
                  ? [
                      BoxShadow(
                        color: colors.inverseSurface.withOpacity(0.18),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ]
                  : null,
            ),
            child: Center(
              child: Text(
                label,
                style: theme.textTheme.labelLarge?.copyWith(
                  color: selected
                      ? colors.onInverseSurface
                      : colors.onSurfaceVariant,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.1,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _DecisionTile extends StatelessWidget {
  const _DecisionTile({
    required this.decision,
    required this.dateLabel,
    required this.onTap,
  });

  final SavedDecisionModel decision;
  final String dateLabel;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    final metadataStyle = theme.textTheme.bodyMedium?.copyWith(
      color: colors.onSurfaceVariant,
      fontWeight: FontWeight.w500,
    );

    return Material(
      color: colors.surface,
      borderRadius: BorderRadius.circular(16),
      clipBehavior: Clip.antiAlias,
      elevation: 0,
      child: InkWell(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: colors.outlineVariant.withOpacity(0.6)),
            boxShadow: [
              BoxShadow(
                color: colors.shadow.withOpacity(0.04),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      decision.productName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: colors.onSurface,
                        fontWeight: FontWeight.w700,
                        height: 1.2,
                      ),
                    ),

                    const SizedBox(height: 6),

                    Wrap(
                      spacing: 8,
                      runSpacing: 4,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Text(decision.productPrice, style: metadataStyle),
                        ExcludeSemantics(
                          child: Icon(
                            Icons.circle,
                            size: 4,
                            color: colors.outlineVariant,
                          ),
                        ),
                        Text(dateLabel, style: metadataStyle),
                      ],
                    ),

                    const SizedBox(height: 14),

                    _VerdictBadge(verdict: decision.verdict),
                  ],
                ),
              ),

              const SizedBox(width: 8),

              Icon(
                Icons.chevron_right_rounded,
                color: colors.outline,
                size: 22,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _VerdictBadge extends StatelessWidget {
  const _VerdictBadge({required this.verdict});

  final String verdict;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    final Color color;
    final String label;

    switch (verdict.trim().toLowerCase()) {
      case 'buy':
        color = colors.primary;
        label = 'BUY';
        break;

      case 'dont_buy':
        color = colors.error;
        label = "DON'T BUY";
        break;

      case 'wait':
        color = colors.tertiary;
        label = 'WAIT';
        break;

      default:
        color = colors.onSurfaceVariant;
        label = verdict.replaceAll('_', ' ').toUpperCase();
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.10),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Text(
        label,
        style: theme.textTheme.labelMedium?.copyWith(
          color: color,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.3,
        ),
      ),
    );
  }
}

class _EmptyDecisions extends StatelessWidget {
  const _EmptyDecisions({required this.category});

  final String category;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: colors.surfaceVariant.withOpacity(0.5),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.receipt_long_outlined,
                size: 32,
                color: colors.outline,
              ),
            ),

            const SizedBox(height: 18),

            Text(
              category == 'All'
                  ? 'No decisions yet'
                  : 'No decisions in this category',
              textAlign: TextAlign.center,
              style: theme.textTheme.titleMedium?.copyWith(
                color: colors.onSurface,
                fontWeight: FontWeight.w700,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              category == 'All'
                  ? 'Your saved purchase decisions will appear here.'
                  : 'Try another filter to see your saved decisions.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colors.onSurfaceVariant,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
