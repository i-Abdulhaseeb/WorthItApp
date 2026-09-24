import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:worthitapp/app/theme/app_colors.dart';
import 'package:worthitapp/core/utils/responsive.dart';
import 'package:worthitapp/features/purchase/controllers/analysis_controller.dart';
import 'package:worthitapp/features/purchase/controllers/purchase_controller.dart';

/// Final verdict (Buy / Wait / Don't Buy) view displaying detailed AI evaluation
class VerdictView extends GetView<AnalysisController> {
  const VerdictView({super.key});

  PurchaseController get purchaseController =>
      Get.isRegistered<PurchaseController>()
      ? Get.find<PurchaseController>()
      : Get.put(PurchaseController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_rounded,
            color: AppColors.primaryEmerald,
          ),
          onPressed: () => Get.back(),
        ),
        title: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: Responsive.maxContentWidth,
          ),
          child: Text(
            'Verdict',
            style: GoogleFonts.inter(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: AppColors.primaryEmerald,
            ),
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.account_circle_outlined,
              color: AppColors.primaryEmerald,
              size: 26,
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: SafeArea(
        child: ResponsiveCenter(
          maxWidth: Responsive.maxContentWidth,
          padding: EdgeInsets.symmetric(
            horizontal: Responsive.horizontalPadding(context),
            vertical: 12,
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // 1. Verdict Top Section (Title, Verdict Text, Average Score Badge)
                _buildVerdictHeader(),
                const SizedBox(height: 24),

                // 2. Target Product Summary Card (Name, Price, Image)
                _buildProductSummaryCard(),
                const SizedBox(height: 16),

                // 3. Dynamic "Why we're saying {verdict}" Card
                _buildWhyWeAreSayingCard(),
                const SizedBox(height: 24),

                // 4. "Verdict Factors" Header & Breakdown Card
                _buildVerdictFactorsSection(),
                const SizedBox(height: 24),

                // 5. "Save the Decision" Action Button (No-op placeholder)
                _buildDecisionButton('Save the decision', controller, 0),
                const SizedBox(height: 24),
                _buildDecisionButton('Return to home', controller, 1),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // 1. Verdict Header & Score Pill
  // ---------------------------------------------------------------------------
  Widget _buildVerdictHeader() {
    return Obx(() {
      final verdictName = controller.verdictDisplayName;
      final Color verdictColor = _getVerdictColor(verdictName);
      final int avgScore = controller.averageScore;

      return Column(
        children: [
          const SizedBox(height: 4),
          Text(
            'YOUR VERDICT',
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.2,
              color: const Color(0xFF4B5563),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            verdictName,
            style: GoogleFonts.inter(
              fontSize: 32,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.5,
              color: verdictColor,
            ),
          ),
          const SizedBox(height: 10),
          // Score Pill Badge (e.g. 64 / 100)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
            decoration: BoxDecoration(
              color: verdictColor.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: verdictColor.withValues(alpha: 0.5),
                width: 1.2,
              ),
            ),
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: '$avgScore',
                    style: GoogleFonts.inter(
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                      color: verdictColor,
                    ),
                  ),
                  TextSpan(
                    text: ' / 100',
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF9CA3AF),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    });
  }

  // ---------------------------------------------------------------------------
  // 2. Product Summary Card (Name, Price, Thumbnail)
  // ---------------------------------------------------------------------------
  Widget _buildProductSummaryCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderLight, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Name and Price
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Obx(() {
                  final name = purchaseController.productName.value.trim();
                  final link = purchaseController.productLink.value.trim();
                  final displayName = name.isNotEmpty
                      ? name
                      : (link.isNotEmpty ? link : 'Product Name');

                  return Text(
                    displayName,
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.onSurface,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  );
                }),
                const SizedBox(height: 4),
                Obx(() {
                  final priceText = purchaseController.productPrice.value
                      .trim();
                  final displayPrice = priceText.isNotEmpty
                      ? (priceText.startsWith('Rs.') ||
                                priceText.startsWith('\$')
                            ? priceText
                            : 'Rs. $priceText')
                      : 'Rs. 0';

                  return Text(
                    displayPrice,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF6B7280),
                    ),
                  );
                }),
              ],
            ),
          ),
          const SizedBox(width: 14),

          // Product Image Thumbnail
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Container(
              width: 60,
              height: 60,
              color: const Color(0xFFF3F4F6),
              child: Obx(() {
                final image = purchaseController.selectedImage.value;
                if (image != null && File(image.path).existsSync()) {
                  return Image.file(
                    File(image.path),
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                  );
                }
                return const Center(
                  child: Icon(
                    Icons.shopping_bag_outlined,
                    color: Color(0xFF9CA3AF),
                    size: 28,
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // 3. "Why we're saying {verdict}" Card
  // ---------------------------------------------------------------------------
  Widget _buildWhyWeAreSayingCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderLight, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Lightbulb Icon + Title
          Row(
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFFFFFBEB),
                ),
                child: const Icon(
                  Icons.lightbulb_outline_rounded,
                  size: 18,
                  color: Color(0xFFF59E0B),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Obx(
                  () => Text(
                    controller.whySayingTitle,
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.onSurface,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          const Divider(height: 1, color: AppColors.borderLight),
          const SizedBox(height: 14),

          // Reason Content
          Obx(() {
            final reasonText = controller.reason.value.trim();
            final recText = controller.recommendation.value.trim();
            final displayText = reasonText.isNotEmpty
                ? reasonText
                : (recText.isNotEmpty
                      ? recText
                      : 'The analysis is based on your answers regarding necessity, affordability, alternatives, and usage.');

            return Text(
              displayText,
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: const Color(0xFF374151),
                height: 1.55,
              ),
            );
          }),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // 4. "Verdict Factors" Section with colored progress bars
  // ---------------------------------------------------------------------------
  Widget _buildVerdictFactorsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Verdict Factors',
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppColors.onSurface,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.borderLight, width: 1),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.02),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Obx(() {
            return Column(
              children: [
                _buildFactorItem(
                  label: 'Affordability',
                  score: controller.affordability.value,
                ),
                const SizedBox(height: 16),
                _buildFactorItem(
                  label: 'Necessity',
                  score: controller.necessity.value,
                ),
                const SizedBox(height: 16),
                _buildFactorItem(label: 'Value', score: controller.value.value),
                const SizedBox(height: 16),
                _buildFactorItem(label: 'Usage', score: controller.usage.value),
                const SizedBox(height: 16),
                _buildFactorItem(
                  label: 'Alternative',
                  score: controller.alternative.value,
                ),
                const SizedBox(height: 16),
                _buildFactorItem(
                  label: 'Impulse Risk',
                  score: controller.impulseRisk.value,
                ),
              ],
            );
          }),
        ),
      ],
    );
  }

  // Single Factor Item (Label + Score + Progress Bar)
  Widget _buildFactorItem({required String label, required int score}) {
    final factorColor = _getFactorScoreColor(score);
    final double progress = (score / 100.0).clamp(0.0, 1.0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF1F2937),
              ),
            ),
            Text(
              '$score',
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: factorColor,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 4.5,
            backgroundColor: const Color(0xFFF3F4F6),
            valueColor: AlwaysStoppedAnimation<Color>(factorColor),
          ),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // 5. "Save the Decision" Button (No-op action for now)
  // ---------------------------------------------------------------------------
  Widget _buildDecisionButton(
    String text,
    AnalysisController controller,
    int check,
  ) {
    return Container(
      width: double.infinity,
      height: 54,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderLight, width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            check == 0 ? controller.saveDecision() : controller.getToHome();
          },
          child: Center(
            child: Text(
              text,
              style: GoogleFonts.inter(
                fontSize: 15.5,
                fontWeight: FontWeight.w700,
                color: AppColors.onSurface,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Color Helpers
  // ---------------------------------------------------------------------------
  Color _getVerdictColor(String verdict) {
    final v = verdict.toLowerCase().trim();
    if (v.contains('buy') && !v.contains("don't") && !v.contains('dont')) {
      return const Color(0xFF059669); // Green
    } else if (v.contains("don't") || v.contains('dont')) {
      return const Color(0xFFDC2626); // Red
    }
    return const Color(0xFFF97316); // Orange for WAIT
  }

  /// Factor color logic:
  /// - Red (< 40): Very Low
  /// - Orange (40 - 69): Mid
  /// - Green (>= 70): High
  Color _getFactorScoreColor(int score) {
    if (score < 40) {
      return const Color(0xFFDC2626); // Red
    } else if (score < 70) {
      return const Color(0xFFF97316); // Orange
    } else {
      return const Color(0xFF059669); // Green
    }
  }
}
