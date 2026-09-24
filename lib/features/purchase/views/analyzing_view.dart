import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:worthitapp/app/theme/app_colors.dart';
import 'package:worthitapp/app/theme/app_text_styles.dart';
import 'package:worthitapp/core/utils/responsive.dart';
import '../controllers/analysis_controller.dart';

/// Loading / AI evaluation in-progress view
class AnalyzingView extends GetView<AnalysisController> {
  const AnalyzingView({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: ResponsiveCenter(
          maxWidth: Responsive.maxContentWidth,
          padding: EdgeInsets.symmetric(
            horizontal: Responsive.horizontalPadding(context),
            vertical: 16,
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 8),
                // Top Brand Header (No back arrow as requested)
                _buildBrandHeader(),
                const SizedBox(height: 24),

                // Title and Subtitle
                Text(
                  'Analyzing your purchase',
                  textAlign: TextAlign.center,
                  style: textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: AppColors.onSurface,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Give us a moment — we're running the numbers,\nchecking the details, and looking at the bigger picture.",
                  textAlign: TextAlign.center,
                  style: AppTextStyles.bodySm.copyWith(
                    color: AppColors.onSurfaceVariant,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 24),

                // Center Illustration (Paper + Magnifying Glass + Orbits)
                const _AnalyzingIllustration(),
                const SizedBox(height: 24),

                // Section Divider: "ANALYZING WHAT MATTERS"
                _buildSectionDivider(),
                const SizedBox(height: 16),

                // Progress Bar and Percentage
                _buildProgressBar(),
                const SizedBox(height: 20),

                // Checklist Card (4 sequential steps)
                _buildChecklistCard(textTheme),
                const SizedBox(height: 20),

                // Bottom Quote / Value Banner
                _buildBottomBanner(),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Top Brand Header
  // ---------------------------------------------------------------------------
  Widget _buildBrandHeader() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Worth It',
          style: AppTextStyles.sectionTitle.copyWith(
            fontWeight: FontWeight.w800,
            fontSize: 22,
            color: AppColors.primary,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          'BETTER DECISIONS. A CALMER YOU.',
          style: AppTextStyles.labelBold.copyWith(
            fontSize: 9,
            letterSpacing: 1.4,
            fontWeight: FontWeight.w700,
            color: AppColors.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // Section Divider
  // ---------------------------------------------------------------------------
  Widget _buildSectionDivider() {
    return Row(
      children: [
        const Expanded(
          child: Divider(color: AppColors.borderLight, thickness: 1),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            'ANALYZING WHAT MATTERS',
            style: AppTextStyles.labelBold.copyWith(
              fontSize: 10,
              letterSpacing: 1.5,
              fontWeight: FontWeight.w600,
              color: AppColors.onSurfaceVariant,
            ),
          ),
        ),
        const Expanded(
          child: Divider(color: AppColors.borderLight, thickness: 1),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // Progress Bar & Percentage
  // ---------------------------------------------------------------------------
  Widget _buildProgressBar() {
    return Obx(() {
      final double progressValue = controller.progress.value.clamp(0.0, 1.0);
      final int percent = (progressValue * 100).toInt();

      return Row(
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: progressValue,
                minHeight: 8,
                backgroundColor: AppColors.surfaceContainerHigh,
                valueColor: const AlwaysStoppedAnimation<Color>(
                  AppColors.primaryContainer,
                ),
              ),
            ),
          ),
          const SizedBox(width: 14),
          Text(
            '$percent%',
            style: AppTextStyles.bodySm.copyWith(
              fontWeight: FontWeight.w700,
              color: AppColors.primary,
            ),
          ),
        ],
      );
    });
  }

  // ---------------------------------------------------------------------------
  // Checklist Card with 4 sequential items
  // ---------------------------------------------------------------------------
  Widget _buildChecklistCard(TextTheme textTheme) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.borderLight, width: 1),
      ),
      child: Column(
        children: [
          for (int i = 0; i < controller.steps.length; i++) ...[
            _buildChecklistItem(controller.steps[i], textTheme),
            if (i < controller.steps.length - 1)
              const Divider(
                height: 1,
                indent: 64,
                endIndent: 20,
                color: AppColors.surfaceContainerLow,
              ),
          ],
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Single Checklist Row Item
  // ---------------------------------------------------------------------------
  Widget _buildChecklistItem(AnalysisStepItem step, TextTheme textTheme) {
    return Obx(() {
      final status = step.status.value;

      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Status Icon Indicator
            _buildStatusIcon(status),
            const SizedBox(width: 14),

            // Title & Subtitle
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    step.title,
                    style: textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: AppColors.onSurface,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    step.subtitle,
                    style: AppTextStyles.bodySm.copyWith(
                      color: AppColors.onSurfaceVariant,
                      fontSize: 12.5,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),

            // Trailing Status Text
            _buildStatusText(status),
          ],
        ),
      );
    });
  }

  // ---------------------------------------------------------------------------
  // Status Icon Widget
  // ---------------------------------------------------------------------------
  Widget _buildStatusIcon(AnalysisStepStatus status) {
    switch (status) {
      case AnalysisStepStatus.done:
        return Container(
          width: 36,
          height: 36,
          decoration: const BoxDecoration(
            color: AppColors.primaryContainer,
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.check, color: Colors.white, size: 20),
        );
      case AnalysisStepStatus.inProgress:
        return Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.borderLight, width: 1.5),
          ),
          child: const Padding(
            padding: EdgeInsets.all(7),
            child: CircularProgressIndicator(
              strokeWidth: 2.2,
              valueColor: AlwaysStoppedAnimation<Color>(
                AppColors.primaryContainer,
              ),
            ),
          ),
        );
      case AnalysisStepStatus.pending:
        return Container(
          width: 36,
          height: 36,
          decoration: const BoxDecoration(
            color: AppColors.surfaceContainerHighest,
            shape: BoxShape.circle,
          ),
        );
    }
  }

  // ---------------------------------------------------------------------------
  // Status Text Widget
  // ---------------------------------------------------------------------------
  Widget _buildStatusText(AnalysisStepStatus status) {
    switch (status) {
      case AnalysisStepStatus.done:
        return Text(
          'Done',
          style: AppTextStyles.bodySm.copyWith(
            fontWeight: FontWeight.w600,
            color: AppColors.primary,
            fontSize: 13,
          ),
        );
      case AnalysisStepStatus.inProgress:
        return Text(
          'In progress',
          style: AppTextStyles.bodySm.copyWith(
            fontWeight: FontWeight.w500,
            color: AppColors.onSurfaceVariant,
            fontSize: 13,
          ),
        );
      case AnalysisStepStatus.pending:
        return Text(
          'Pending',
          style: AppTextStyles.bodySm.copyWith(
            fontWeight: FontWeight.w500,
            color: AppColors.outlineVariant,
            fontSize: 13,
          ),
        );
    }
  }

  // ---------------------------------------------------------------------------
  // Bottom Motivational Banner
  // ---------------------------------------------------------------------------
  Widget _buildBottomBanner() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerHigh.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          // Sprout / plant icon
          const Icon(
            Icons.eco_outlined,
            size: 26,
            color: AppColors.primary,
          ),
          const SizedBox(width: 14),
          // Vertical divider line
          Container(
            width: 1,
            height: 28,
            color: AppColors.outlineVariant.withValues(alpha: 0.5),
          ),
          const SizedBox(width: 14),
          // Slogan
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'A MORE THOUGHTFUL YOU',
                  style: AppTextStyles.labelBold.copyWith(
                    fontSize: 9.5,
                    letterSpacing: 1.2,
                    fontWeight: FontWeight.w700,
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'BUILDS A BRIGHTER TOMORROW.',
                  style: AppTextStyles.labelBold.copyWith(
                    fontSize: 9.5,
                    letterSpacing: 1.2,
                    fontWeight: FontWeight.w700,
                    color: AppColors.onSurfaceVariant,
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

// =============================================================================
// Illustration: Custom vector drawing matching document & magnifying glass
// =============================================================================
class _AnalyzingIllustration extends StatelessWidget {
  const _AnalyzingIllustration();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 140,
      width: 260,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Orbital background ellipses with floating dots
          CustomPaint(
            size: const Size(260, 140),
            painter: _OrbitPainter(),
          ),

          // Document receipt card
          Transform.rotate(
            angle: -0.06,
            child: Container(
              width: 86,
              height: 104,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerLowest,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: AppColors.borderLight,
                  width: 1.2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Shopping bag icon
                  Icon(
                    Icons.shopping_bag_outlined,
                    size: 18,
                    color: AppColors.outlineVariant,
                  ),
                  const SizedBox(height: 8),
                  // Placeholder text lines
                  Container(
                    height: 3.5,
                    width: 44,
                    decoration: BoxDecoration(
                      color: AppColors.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Container(
                    height: 3.5,
                    width: 58,
                    decoration: BoxDecoration(
                      color: AppColors.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Container(
                    height: 3.5,
                    width: 32,
                    decoration: BoxDecoration(
                      color: AppColors.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Magnifying Glass over document
          Positioned(
            right: 88,
            bottom: 22,
            child: SizedBox(
              width: 44,
              height: 44,
              child: Stack(
                children: [
                  // Lens
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withValues(alpha: 0.7),
                      border: Border.all(
                        color: AppColors.onSurfaceVariant,
                        width: 3,
                      ),
                    ),
                  ),
                  // Glass reflection
                  Positioned(
                    top: 5,
                    left: 7,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withValues(alpha: 0.8),
                      ),
                    ),
                  ),
                  // Handle
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Transform.rotate(
                      angle: 0.75,
                      child: Container(
                        width: 6,
                        height: 16,
                        decoration: BoxDecoration(
                          color: AppColors.onSurfaceVariant,
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Painter for the orbital background rings and decorative dots
class _OrbitPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    final orbitPaint = Paint()
      ..color = AppColors.outlineVariant.withValues(alpha: 0.35)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    // Draw outer orbit ellipse
    canvas.drawOval(
      Rect.fromCenter(
        center: center,
        width: size.width * 0.95,
        height: size.height * 0.65,
      ),
      orbitPaint,
    );

    // Draw inner orbit ellipse
    canvas.drawOval(
      Rect.fromCenter(
        center: center,
        width: size.width * 0.75,
        height: size.height * 0.48,
      ),
      orbitPaint,
    );

    final dotPaint = Paint()
      ..color = AppColors.primary
      ..style = PaintingStyle.fill;

    // Draw decorative dots along orbits
    canvas.drawCircle(Offset(center.dx - 100, center.dy + 8), 3.0, dotPaint);
    canvas.drawCircle(
      Offset(center.dx + 90, center.dy - 12),
      2.5,
      Paint()..color = AppColors.outlineVariant,
    );
    canvas.drawCircle(Offset(center.dx + 105, center.dy + 16), 3.5, dotPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

