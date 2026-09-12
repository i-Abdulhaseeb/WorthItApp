import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:worthitapp/app/theme/app_colors.dart';
import 'package:worthitapp/app/theme/app_text_styles.dart';
import 'package:worthitapp/core/question_engine/question_templates.dart';

import '../controllers/purchase_controller.dart';

/// Pre-analysis review view
class ReviewView extends GetView<PurchaseController> {
  const ReviewView({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Review answers',
          style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(textTheme),
                    const SizedBox(height: 20),
                    _buildTargetPurchaseCard(textTheme),
                    const SizedBox(height: 16),
                    _buildReadinessCard(textTheme),
                    const SizedBox(height: 16),
                    _buildCriteriaAuditCard(textTheme, controller),
                    const SizedBox(height: 16),
                    _buildImpartialBanner(textTheme),
                  ],
                ),
              ),
            ),
            _buildBottomAction(context, textTheme),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------
  // Header
  // ---------------------------------------------------------------------
  Widget _buildHeader(TextTheme textTheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.verified_outlined,
              size: 16,
              color: AppColors.primaryEmerald,
            ),
            const SizedBox(width: 6),
            Text(
              'FINAL VERIFICATION',
              style: AppTextStyles.bodySm.copyWith(
                color: AppColors.primaryEmerald,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.6,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          "Here's what we know",
          style: textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 6),
        Text(
          'Take a quick look before we make the call.',
          style: AppTextStyles.bodyLg.copyWith(
            color: AppColors.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------
  // Target purchase card
  // ---------------------------------------------------------------------
  Widget _buildTargetPurchaseCard(TextTheme textTheme) {
    return _CardContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _SectionLabel('TARGET PURCHASE'),
                    const SizedBox(height: 6),
                    Text(
                      controller.productName.value,
                      style: textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              _EditButton(
                onTap: () {
                  // TODO: controller.editTargetPurchase();
                },
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(height: 1),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Retail listing price',
                style: AppTextStyles.bodyLg.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
              ),
              Text(
                controller.productPrice.value,
                style: textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------
  // Readiness card
  // ---------------------------------------------------------------------
  Widget _buildReadinessCard(TextTheme textTheme) {
    // TODO: replace with controller values
    const readinessText = 'Analysis ready in < 5 seconds';
    const synthesisTag = 'Instant synthesis';

    return _CardContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _IconBadge(icon: Icons.hourglass_top_rounded),
          const SizedBox(height: 14),
          _SectionLabel('READINESS'),
          const SizedBox(height: 6),
          Text(
            readinessText,
            style: textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 14),
          const Divider(height: 1),
          const SizedBox(height: 14),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.bolt_rounded,
                size: 16,
                color: AppColors.primaryEmerald,
              ),
              const SizedBox(width: 6),
              Text(
                synthesisTag,
                style: AppTextStyles.bodySm.copyWith(
                  color: AppColors.primaryEmerald,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------
  // Criteria audit card
  // ---------------------------------------------------------------------
  Widget _buildCriteriaAuditCard(
    TextTheme textTheme,
    PurchaseController controller,
  ) {
    final questionController = controller.questionController;

    // ---------------------------------------------------------
    // Helper: Get the human-readable selected option title
    // ---------------------------------------------------------
    String getOptionAnswer(String questionId) {
      final answer = questionController.answerFor(questionId);

      if (answer == null || answer.skipped) {
        return 'Not answered';
      }

      if (answer.selectedOptionId == null) {
        return answer.freeTextValue ?? 'Not answered';
      }

      final question = findQuestionById(questionId);

      if (question == null) {
        return answer.selectedOptionId!;
      }

      final selectedOption = question.options.firstWhere(
        (option) => option.id == answer.selectedOptionId,
        orElse: () => question.options.first,
      );

      return selectedOption.title;
    }

    // ---------------------------------------------------------
    // Cheaper alternative
    // ---------------------------------------------------------
    String alternativeName = '';
    String alternativePrice = '';

    final alternativeAnswer = questionController.answerFor(
      'cheaper_alternative',
    );

    if (alternativeAnswer != null) {
      alternativeName =
          alternativeAnswer.followUpValues?['alternative_name'] ?? '';

      alternativePrice =
          alternativeAnswer.followUpValues?['alternative_price'] ?? '';
    }

    // ---------------------------------------------------------
    // Criteria
    // ---------------------------------------------------------
    final criteria = <_CriteriaItem>[
      _CriteriaItem(
        icon: Icons.trending_up_rounded,
        label: 'Motivation',
        value: getOptionAnswer('motivation'),
      ),

      _CriteriaItem(
        icon: Icons.inventory_2_outlined,
        label: 'Existing possession',
        value: getOptionAnswer('already_own_similar'),
      ),

      _CriteriaItem(
        icon: Icons.calendar_today_outlined,
        label: 'Expected usage',
        value: getOptionAnswer('usage_frequency'),
      ),

      _CriteriaItem(
        icon: Icons.compare_arrows_rounded,
        label: 'Cheaper alternative',
        value: getOptionAnswer('cheaper_alternative'),
        trailingValue: alternativePrice.isNotEmpty
            ? '(Rs. $alternativePrice)'
            : null,
      ),

      _CriteriaItem(
        icon: Icons.timer_outlined,
        label: 'Desire & impulse',
        value: getOptionAnswer('how_long_wanted'),
      ),

      _CriteriaItem(
        icon: Icons.work_outline_rounded,
        label: 'Financial impact',
        value: getOptionAnswer('financial_impact'),
      ),
    ];

    return _CardContainer(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _SectionLabel('CRITERIA AUDIT'),
                Text(
                  '${criteria.length} data points',
                  style: AppTextStyles.bodySm.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          for (int i = 0; i < criteria.length; i++) ...[
            const Divider(height: 1),
            _CriteriaRow(item: criteria[i], textTheme: textTheme),
          ],
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------
  // Impartial banner
  // ---------------------------------------------------------------------
  Widget _buildImpartialBanner(TextTheme textTheme) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.shield_outlined,
            size: 20,
            color: AppColors.onSurfaceVariant,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Your evaluation is impartial. Verdict is not affiliated with retailers.',
              style: AppTextStyles.bodySm.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------
  // Bottom CTA
  // ---------------------------------------------------------------------
  Widget _buildBottomAction(BuildContext context, TextTheme textTheme) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
      decoration: BoxDecoration(
        color: AppColors.background,
        border: Border(top: BorderSide(color: AppColors.borderLight, width: 1)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                // TODO: controller.analyzePurchase();
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.auto_awesome_rounded, size: 18),
                  SizedBox(width: 8),
                  Text('Analyze my purchase'),
                  SizedBox(width: 8),
                  Icon(Icons.arrow_forward_rounded, size: 18),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            "We'll use your answers to give you an objective recommendation.",
            textAlign: TextAlign.center,
            style: AppTextStyles.bodySm.copyWith(
              color: AppColors.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

// ===========================================================================
// Shared small widgets
// ===========================================================================

class _CardContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;

  const _CardContainer({
    required this.child,
    this.padding = const EdgeInsets.all(20),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.borderLight, width: 1),
      ),
      child: child,
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: AppTextStyles.bodySm.copyWith(
        color: AppColors.onSurfaceVariant,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.6,
      ),
    );
  }
}

class _EditButton extends StatelessWidget {
  final VoidCallback onTap;
  const _EditButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onTap,
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        foregroundColor: AppColors.primaryEmerald,
      ),
      child: Text(
        'Edit',
        style: AppTextStyles.bodySm.copyWith(
          color: AppColors.primaryEmerald,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _IconBadge extends StatelessWidget {
  final IconData icon;
  const _IconBadge({required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: AppColors.secondaryContainer,
        shape: BoxShape.circle,
      ),
      child: Icon(icon, size: 18, color: AppColors.onSecondaryContainer),
    );
  }
}

class _CriteriaItem {
  final IconData icon;
  final String label;
  final String value;
  final String? trailingValue;

  const _CriteriaItem({
    required this.icon,
    required this.label,
    required this.value,
    this.trailingValue,
  });
}

class _CriteriaRow extends StatelessWidget {
  final _CriteriaItem item;
  final TextTheme textTheme;

  const _CriteriaRow({required this.item, required this.textTheme});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerHigh,
              shape: BoxShape.circle,
            ),
            child: Icon(item.icon, size: 18, color: AppColors.onSurfaceVariant),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.label,
                  style: AppTextStyles.bodySm.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 2),
                RichText(
                  overflow: TextOverflow.ellipsis,
                  text: TextSpan(
                    style: textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.onSurface,
                    ),
                    children: [
                      TextSpan(text: item.value),
                      if (item.trailingValue != null)
                        TextSpan(
                          text: '  ${item.trailingValue}',
                          style: AppTextStyles.bodySm.copyWith(
                            color: AppColors.onSurfaceVariant,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                    ],
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
