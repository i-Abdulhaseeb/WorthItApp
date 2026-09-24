import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:worthitapp/data/models/saved_decision_model.dart';

import '../../../core/utils/responsive.dart';
import '../controllers/decisions_controller.dart';

class DecisionsView extends GetView<DecisionsController> {
  const DecisionsView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final horizontalPad = Responsive.horizontalPadding(context);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: false,
        titleSpacing: horizontalPad,
        title: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: Responsive.maxContentWidth),
            child: Text(
              'Your decisions',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w800,
                color: colors.onSurface,
              ),
            ),
          ),
        ),
      ),
      body: SafeArea(
        top: false,
        bottom: false,
        child: ResponsiveCenter(
          maxWidth: Responsive.maxContentWidth,
          child: Obx(() {
            final sections = controller.sections;

            return CustomScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              slivers: [
                SliverPadding(
                  padding: EdgeInsets.fromLTRB(horizontalPad, 0, horizontalPad, 0),
                  sliver: SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'See what you bought, skipped, or decided to wait on.',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: colors.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 18),
                        _SummaryCard(controller: controller),
                        const SizedBox(height: 18),
                        _CategoryFilters(controller: controller),
                        const SizedBox(height: 12),
                        _SearchAndSort(controller: controller),
                        const SizedBox(height: 22),
                      ],
                    ),
                  ),
                ),

                if (sections.isEmpty)
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: _EmptyState(
                      hasSavedDecisions: controller.totalCount > 0,
                    ),
                  ),

                for (final section in sections) ...[
                  SliverPadding(
                    padding: EdgeInsets.fromLTRB(horizontalPad + 2, 0, horizontalPad, 10),
                    sliver: SliverToBoxAdapter(
                      child: Text(
                        section.title,
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: colors.outline,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.8,
                        ),
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding: EdgeInsets.symmetric(horizontal: horizontalPad - 4),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        final decision = section.decisions[index];

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: _DecisionTile(
                            decision: decision,
                            dateLabel: controller.formatDate(decision.decidedAt),
                            onTap: () => controller.onDecisionTap(decision),
                          ),
                        );
                      }, childCount: section.decisions.length),
                    ),
                  ),
                  const SliverToBoxAdapter(child: SizedBox(height: 18)),
                ],

                const SliverToBoxAdapter(child: SizedBox(height: 12)),
              ],
            );
          }),
        ),
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({required this.controller});

  final DecisionsController controller;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Obx(() {
      final bought = controller.countFor('buy');
      final avoided = controller.countFor('dont_buy');
      final waiting = controller.countFor('wait');

      return Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: _SummaryMetric(
                    label: 'Total',
                    value: controller.totalCount,
                    footer: 'All logs',
                    color: colors.onSurface,
                  ),
                ),
                const VerticalDivider(width: 1),
                Expanded(
                  child: _SummaryMetric(
                    label: 'Bought',
                    value: bought,
                    footer: controller.percentageFor(bought),
                    color: colors.primary,
                    icon: Icons.check_circle_outline_rounded,
                  ),
                ),
                const VerticalDivider(width: 1),
                Expanded(
                  child: _SummaryMetric(
                    label: 'Avoided',
                    value: avoided,
                    footer: controller.percentageFor(avoided),
                    color: colors.error,
                    icon: Icons.cancel_outlined,
                  ),
                ),
                const VerticalDivider(width: 1),
                Expanded(
                  child: _SummaryMetric(
                    label: 'Waiting',
                    value: waiting,
                    footer: controller.percentageFor(waiting),
                    color: colors.tertiary,
                    icon: Icons.schedule_rounded,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}

class _SummaryMetric extends StatelessWidget {
  const _SummaryMetric({
    required this.label,
    required this.value,
    required this.footer,
    required this.color,
    this.icon,
  });

  final String label;
  final int value;
  final String footer;
  final Color color;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 3),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Wrap(
            alignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 3,
            children: [
              if (icon != null) Icon(icon, size: 12, color: color),
              Text(
                label,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: color,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),
          Text(
            '$value',
            style: theme.textTheme.titleLarge?.copyWith(
              color: color,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            footer,
            textAlign: TextAlign.center,
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.outline,
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryFilters extends StatelessWidget {
  const _CategoryFilters({required this.controller});

  final DecisionsController controller;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Obx(() {
        final selected = controller.selectedCategory.value;

        return Row(
          children: controller.categories.map((category) {
            final active = selected == category;

            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: ChoiceChip(
                label: Text(category),
                selected: active,
                showCheckmark: false,
                onSelected: (_) => controller.selectCategory(category),
                selectedColor: colors.primary,
                backgroundColor: theme.cardTheme.color,
                side: BorderSide(
                  color: active
                      ? colors.primary
                      : colors.outlineVariant.withValues(alpha: 0.4),
                ),
                shape: const StadiumBorder(),
                padding: const EdgeInsets.symmetric(horizontal: 7),
                labelStyle: theme.textTheme.labelMedium?.copyWith(
                  color: active ? colors.onPrimary : colors.onSurfaceVariant,
                  fontWeight: FontWeight.w600,
                ),
                materialTapTargetSize: MaterialTapTargetSize.padded,
              ),
            );
          }).toList(),
        );
      }),
    );
  }
}

class _SearchAndSort extends StatelessWidget {
  const _SearchAndSort({required this.controller});

  final DecisionsController controller;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: TextField(
            controller: controller.searchController,
            onChanged: controller.updateSearch,
            style: theme.textTheme.bodySmall,
            textInputAction: TextInputAction.search,
            decoration: InputDecoration(
              hintText: 'Search decisions...',
              prefixIcon: Icon(
                Icons.search_rounded,
                size: 21,
                color: colors.outline,
              ),
              suffixIcon: Obx(
                () => controller.searchQuery.value.isEmpty
                    ? const SizedBox.shrink()
                    : IconButton(
                        tooltip: 'Clear search',
                        onPressed: controller.clearSearch,
                        icon: const Icon(Icons.close_rounded, size: 18),
                      ),
              ),
              suffixIconConstraints: const BoxConstraints(
                minWidth: 0,
                minHeight: 48,
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Obx(
          () => PopupMenuButton<bool>(
            tooltip: 'Sort decisions',
            initialValue: controller.newestFirst.value,
            onSelected: controller.setSort,
            itemBuilder: (_) => [
              CheckedPopupMenuItem(
                value: true,
                checked: controller.newestFirst.value,
                child: const Text('Newest first'),
              ),
              CheckedPopupMenuItem(
                value: false,
                checked: !controller.newestFirst.value,
                child: const Text('Oldest first'),
              ),
            ],
            child: Container(
              constraints: const BoxConstraints(minHeight: 48),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: theme.cardTheme.color,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: colors.outlineVariant.withValues(alpha: 0.4),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.swap_vert_rounded,
                    size: 18,
                    color: colors.onSurfaceVariant,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    controller.newestFirst.value ? 'Newest' : 'Oldest',
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: colors.onSurfaceVariant,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
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

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: LayoutBuilder(
            builder: (context, constraints) {
              // Keep the badge below the text on very narrow layouts.
              final compact = constraints.maxWidth < 310;
              final badge = _VerdictBadge(verdict: decision.verdict);

              return Row(
                children: [
                  _DecisionImage(
                    path: decision.imagePath,
                    productName: decision.productName,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          decision.productName,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.titleSmall?.copyWith(
                            color: colors.onSurface,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Wrap(
                          spacing: 7,
                          runSpacing: 3,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            Text(
                              decision.productPrice,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: colors.onSurfaceVariant,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              '•',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: colors.outlineVariant,
                              ),
                            ),
                            Text(
                              dateLabel,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: colors.outline,
                              ),
                            ),
                          ],
                        ),
                        if (compact) ...[const SizedBox(height: 8), badge],
                      ],
                    ),
                  ),
                  if (!compact) ...[const SizedBox(width: 10), badge],
                  const SizedBox(width: 6),
                  Icon(
                    Icons.chevron_right_rounded,
                    size: 20,
                    color: colors.outlineVariant,
                  ),
                ],
              );
            },
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
    final IconData icon;

    switch (verdict.trim().toLowerCase()) {
      case 'buy':
        color = colors.primary;
        label = 'BUY';
        icon = Icons.check_rounded;
        break;
      case 'dont_buy':
        color = colors.error;
        label = "DON'T BUY";
        icon = Icons.close_rounded;
        break;
      case 'wait':
        color = colors.tertiary;
        label = 'WAIT';
        icon = Icons.schedule_rounded;
        break;
      default:
        color = colors.onSurfaceVariant;
        label = verdict.replaceAll('_', ' ').toUpperCase();
        icon = Icons.help_outline_rounded;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: color.withValues(alpha: 0.16)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _DecisionImage extends StatefulWidget {
  const _DecisionImage({required this.path, required this.productName});

  final String? path;
  final String productName;

  @override
  State<_DecisionImage> createState() => _DecisionImageState();
}

class _DecisionImageState extends State<_DecisionImage> {
  Future<Uint8List?>? _imageBytes;

  bool get _isNetwork {
    final path = widget.path?.trim() ?? '';
    return path.startsWith('https://') || path.startsWith('http://');
  }

  @override
  void initState() {
    super.initState();
    _prepareImage();
  }

  @override
  void didUpdateWidget(covariant _DecisionImage oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.path != widget.path) {
      _prepareImage();
    }
  }

  void _prepareImage() {
    final path = widget.path?.trim();

    _imageBytes = path == null || path.isEmpty || _isNetwork
        ? null
        : _readImage(path);
  }

  Future<Uint8List?> _readImage(String path) async {
    try {
      return await XFile(path).readAsBytes();
    } catch (_) {
      return null;
    }
  }

  Widget _placeholder(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return ColoredBox(
      color: colors.primary.withValues(alpha: 0.06),
      child: Center(
        child: Icon(Icons.image_outlined, size: 23, color: colors.outline),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      image: true,
      label: widget.productName,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: SizedBox(
          width: 52,
          height: 52,
          child: _isNetwork
              ? Image.network(
                  widget.path!.trim(),
                  fit: BoxFit.cover,
                  excludeFromSemantics: true,
                  errorBuilder: (_, _, _) => _placeholder(context),
                )
              : FutureBuilder<Uint8List?>(
                  future: _imageBytes,
                  builder: (context, snapshot) {
                    final bytes = snapshot.data;

                    if (bytes == null || bytes.isEmpty) {
                      return _placeholder(context);
                    }

                    return Image.memory(
                      bytes,
                      fit: BoxFit.cover,
                      excludeFromSemantics: true,
                      errorBuilder: (_, _, _) => _placeholder(context),
                    );
                  },
                ),
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.hasSavedDecisions});

  final bool hasSavedDecisions;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              hasSavedDecisions
                  ? Icons.search_off_rounded
                  : Icons.receipt_long_outlined,
              size: 40,
              color: colors.outline,
            ),
            const SizedBox(height: 14),
            Text(
              hasSavedDecisions ? 'No matching decisions' : 'No decisions yet',
              textAlign: TextAlign.center,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              hasSavedDecisions
                  ? 'Try another search or category.'
                  : 'Your saved purchase decisions will appear here.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colors.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
