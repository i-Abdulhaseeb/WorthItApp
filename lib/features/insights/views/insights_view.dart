import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/utils/responsive.dart';
import '../controllers/insights_controller.dart';

class InsightsView extends GetView<InsightsController> {
  const InsightsView({super.key});

  // Verdict accents matching the reference.
  static const Color waitColor = Color(0xFFFF901A);
  static const Color dontBuyColor = Color(0xFFCC1010);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final horizontalPad = Responsive.horizontalPadding(context);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: Responsive.maxContentWidth),
            child: Text(
              'INSIGHTS',
              textAlign: TextAlign.center,
              style: theme.textTheme.titleLarge?.copyWith(
                color: colors.primary,
                fontWeight: FontWeight.w800,
                letterSpacing: 1,
              ),
            ),
          ),
        ),
      ),
      body: SafeArea(
        top: false,
        bottom: false,
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(horizontalPad, 20, horizontalPad, 28),
          child: ResponsiveCenter(
            maxWidth: Responsive.maxContentWidth,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Your spending\npatterns',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.headlineLarge?.copyWith(
                    color: colors.onSurface,
                    fontWeight: FontWeight.w800,
                    fontSize: Responsive.isCompact(context) ? 24 : 28,
                    height: 1.2,
                    letterSpacing: -0.8,
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  'Based on your past decisions.',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: colors.onSurfaceVariant,
                    fontSize: Responsive.isCompact(context) ? 14 : 16,
                  ),
                ),
                const SizedBox(height: 28),

              Obx(
                () => _MonthlySummary(
                  total: controller.totalDecisions,
                  avoidedAmount: controller.formattedAvoidedAmount,
                  delayedPercentage: controller.delayedRejectedPercentage,
                ),
              ),

              const SizedBox(height: 18),

              Obx(
                () => _BreakdownCard(
                  total: controller.totalDecisions,
                  buyCount: controller.buyCount,
                  waitCount: controller.waitCount,
                  dontBuyCount: controller.dontBuyCount,
                  buyPercentage: controller.buyPercentage,
                ),
              ),

              const SizedBox(height: 18),

              // Placeholder insight: not calculated from saved decisions.
              _InsightCard(
                title: 'Category Insight',
                icon: Icons.lightbulb_outline_rounded,
                decorativeIcon: Icons.devices_rounded,
                accent: waitColor,
                headline: Text(
                  '"You tend to think twice about electronics."',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: colors.onSurface,
                    fontWeight: FontWeight.w700,
                    height: 1.45,
                  ),
                ),
                description:
                    'Most of your delayed purchases this month were '
                    'electronics, saving you from impulse upgrades.',
              ),

              const SizedBox(height: 18),

              // Placeholder metric: the current model has no waiting duration.
              _InsightCard(
                title: 'Patience Metric',
                icon: Icons.hourglass_empty_rounded,
                decorativeIcon: Icons.timer_outlined,
                accent: colors.primary,
                headline: Text.rich(
                  TextSpan(
                    children: [
                      const TextSpan(text: 'Average waiting period: '),
                      TextSpan(
                        text: '8.4 days',
                        style: TextStyle(color: colors.primary),
                      ),
                    ],
                  ),
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: colors.onSurface,
                    fontWeight: FontWeight.w700,
                    height: 1.45,
                  ),
                ),
                description:
                    'You typically wait over a week before confirming '
                    'high-ticket items. Good restraint.',
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
}

/// Shared soft-elevation look for every panel on this screen: a near-flat
/// white surface, a hairline border, and a wide, low-opacity shadow instead
/// of Material's default hard elevation shadow.
BoxDecoration _panelDecoration(ColorScheme colors) {
  return BoxDecoration(
    color: colors.surface,
    borderRadius: BorderRadius.circular(22),
    border: Border.all(color: colors.outlineVariant.withValues(alpha: 0.4)),
    boxShadow: [
      BoxShadow(
        color: colors.shadow.withValues(alpha: 0.05),
        blurRadius: 24,
        offset: const Offset(0, 10),
      ),
    ],
  );
}

class _MonthlySummary extends StatelessWidget {
  const _MonthlySummary({
    required this.total,
    required this.avoidedAmount,
    required this.delayedPercentage,
  });

  final int total;
  final String avoidedAmount;
  final double delayedPercentage;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Container(
      decoration: _panelDecoration(colors),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'THIS MONTH',
              textAlign: TextAlign.center,
              style: theme.textTheme.labelLarge?.copyWith(
                color: colors.onSurfaceVariant,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.8,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '$total ${total == 1 ? 'Decision' : 'Decisions'}',
              textAlign: TextAlign.center,
              style: theme.textTheme.headlineMedium?.copyWith(
                color: colors.onSurface,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Active considerations managed through WorthIt.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: colors.onSurfaceVariant,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 26),
            _MetricRow(
              icon: Icons.savings_outlined,
              label: 'Avoided',
              value: avoidedAmount,
              iconColor: colors.primary,
              valueColor: colors.primary,
            ),
            const SizedBox(height: 10),
            _MetricRow(
              icon: Icons.pause_circle_outline_rounded,
              label: 'Delayed/Rejected',
              value: '${delayedPercentage.round()}%',
              iconColor: InsightsView.waitColor,
              valueColor: colors.onSurface,
            ),
          ],
        ),
      ),
    );
  }
}

class _MetricRow extends StatelessWidget {
  const _MetricRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.iconColor,
    required this.valueColor,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color iconColor;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: colors.onSurface.withValues(alpha: 0.045),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: colors.outlineVariant.withValues(alpha: 0.35),
        ),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final labelWidget = Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 17, color: iconColor),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  label,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colors.onSurfaceVariant,
                  ),
                ),
              ),
            ],
          );

          final valueWidget = Text(
            value,
            style: theme.textTheme.titleLarge?.copyWith(
              color: valueColor,
              fontWeight: FontWeight.w700,
            ),
          );

          if (constraints.maxWidth < 270) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [labelWidget, const SizedBox(height: 8), valueWidget],
            );
          }

          return Row(
            children: [
              Expanded(child: labelWidget),
              const SizedBox(width: 12),
              Flexible(child: valueWidget),
            ],
          );
        },
      ),
    );
  }
}

class _BreakdownCard extends StatelessWidget {
  const _BreakdownCard({
    required this.total,
    required this.buyCount,
    required this.waitCount,
    required this.dontBuyCount,
    required this.buyPercentage,
  });

  final int total;
  final int buyCount;
  final int waitCount;
  final int dontBuyCount;
  final double buyPercentage;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Container(
      decoration: _panelDecoration(colors),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Decision Breakdown',
              style: theme.textTheme.titleLarge?.copyWith(
                color: colors.onSurface,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 32),
            Center(
              child: Semantics(
                label:
                    '$total decisions this month. '
                    '$buyCount buy, $waitCount wait, '
                    '$dontBuyCount don’t buy.',
                child: SizedBox(
                  width: 210,
                  height: 210,
                  child: CustomPaint(
                    painter: _VerdictDonutPainter(
                      total: total,
                      buyCount: buyCount,
                      waitCount: waitCount,
                      dontBuyCount: dontBuyCount,
                      buyColor: colors.primary,
                      waitColor: InsightsView.waitColor,
                      dontBuyColor: InsightsView.dontBuyColor,
                      trackColor: colors.onSurface.withValues(alpha: 0.08),
                    ),
                    child: Center(
                      child: ExcludeSemantics(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              total == 0 ? '0' : '${buyPercentage.round()}%',
                              style: theme.textTheme.titleSmall?.copyWith(
                                color: colors.onSurface,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 1,
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              total == 0 ? 'NO DATA' : 'BUY',
                              style: theme.textTheme.labelLarge?.copyWith(
                                color: colors.onSurface,
                                letterSpacing: 1.2,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),
            Center(
              child: Wrap(
                alignment: WrapAlignment.center,
                spacing: 18,
                runSpacing: 12,
                children: [
                  _LegendItem(label: 'BUY', color: colors.primary),
                  const _LegendItem(
                    label: 'WAIT',
                    color: InsightsView.waitColor,
                  ),
                  const _LegendItem(
                    label: "DON'T BUY",
                    color: InsightsView.dontBuyColor,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 4),
          ],
        ),
      ),
    );
  }
}

class _VerdictDonutPainter extends CustomPainter {
  const _VerdictDonutPainter({
    required this.total,
    required this.buyCount,
    required this.waitCount,
    required this.dontBuyCount,
    required this.buyColor,
    required this.waitColor,
    required this.dontBuyColor,
    required this.trackColor,
  });

  final int total;
  final int buyCount;
  final int waitCount;
  final int dontBuyCount;
  final Color buyColor;
  final Color waitColor;
  final Color dontBuyColor;
  final Color trackColor;

  @override
  void paint(Canvas canvas, Size size) {
    const strokeWidth = 20.0;
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (math.min(size.width, size.height) - strokeWidth) / 2;
    final rect = Rect.fromCircle(center: center, radius: radius);

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.butt
      ..isAntiAlias = true;

    paint.color = trackColor;
    canvas.drawCircle(center, radius, paint);

    if (total == 0) return;

    // Wait begins at the top; Buy finishes on the upper-left.
    final counts = [waitCount, dontBuyCount, buyCount];
    final segmentColors = [waitColor, dontBuyColor, buyColor];

    var startAngle = -math.pi / 2;

    for (var i = 0; i < counts.length; i++) {
      if (counts[i] == 0) continue;

      final sweepAngle = counts[i] / total * 2 * math.pi;
      paint.color = segmentColors[i];

      canvas.drawArc(rect, startAngle, sweepAngle, false, paint);
      startAngle += sweepAngle;
    }
  }

  @override
  bool shouldRepaint(covariant _VerdictDonutPainter oldDelegate) {
    return total != oldDelegate.total ||
        buyCount != oldDelegate.buyCount ||
        waitCount != oldDelegate.waitCount ||
        dontBuyCount != oldDelegate.dontBuyCount ||
        buyColor != oldDelegate.buyColor ||
        waitColor != oldDelegate.waitColor ||
        dontBuyColor != oldDelegate.dontBuyColor ||
        trackColor != oldDelegate.trackColor;
  }
}

class _LegendItem extends StatelessWidget {
  const _LegendItem({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 5),
        Text(
          label,
          style: theme.textTheme.labelMedium?.copyWith(
            color: theme.colorScheme.onSurface,
            letterSpacing: 0.3,
          ),
        ),
      ],
    );
  }
}

class _InsightCard extends StatelessWidget {
  const _InsightCard({
    required this.title,
    required this.icon,
    required this.decorativeIcon,
    required this.accent,
    required this.headline,
    required this.description,
  });

  final String title;
  final IconData icon;
  final IconData decorativeIcon;
  final Color accent;
  final Widget headline;
  final String description;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Container(
      decoration: _panelDecoration(colors),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          Positioned(
            top: 22,
            right: 18,
            child: ExcludeSemantics(
              child: Icon(
                decorativeIcon,
                size: 62,
                color: colors.onSurface.withValues(alpha: 0.10),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: accent.withValues(alpha: 0.10),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(icon, color: accent, size: 25),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        title,
                        style: theme.textTheme.titleLarge?.copyWith(
                          color: colors.onSurface,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(width: 30),
                  ],
                ),
                const SizedBox(height: 16),
                headline,
                const SizedBox(height: 6),
                Text(
                  description,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: colors.onSurfaceVariant,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
