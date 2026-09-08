import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:worthitapp/features/purchase/widgets/evaluation_progress.dart';

import '../../../app/routes/app_routes.dart';
import '../../../app/theme/app_colors.dart';
import '../controllers/purchase_controller.dart';

/// Product details view matching the design reference with user-specified modifications.
class ProductDetailsView extends GetView<PurchaseController> {
  const ProductDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        automaticallyImplyLeading: true,
      ),
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Scrollable Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Step indicator and Status
                    EvaluationProgress(purchaseController: controller),
                    const SizedBox(height: 8),

                    // Progress Bar
                    Obx(() {
                      final progress =
                          (controller.currentStep.value / controller.totalSteps)
                              .clamp(0.0, 1.0);
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: progress,
                          minHeight: 4,
                          backgroundColor: const Color(0xFFE5E7EB),
                          valueColor: const AlwaysStoppedAnimation<Color>(
                            AppColors.primary,
                          ),
                        ),
                      );
                    }),
                    const SizedBox(height: 28),

                    // Headline
                    Text(
                      "Let's think this through.",
                      style: GoogleFonts.inter(
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        color: AppColors.onSurface,
                        letterSpacing: -0.5,
                        height: 1.15,
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Subtitle
                    Text(
                      "We'll ask a few questions about why you want this, what you already have, and how it fits into your life.",
                      style: GoogleFonts.inter(
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF4B5563),
                        height: 1.45,
                      ),
                    ),
                    const SizedBox(height: 28),

                    // Product Card
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: const Color(0xFFE5E7EB),
                          width: 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.02),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          // Product Image Thumbnail
                          ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Container(
                              width: 72,
                              height: 72,
                              color: const Color(0xFFF3F4F6),
                              child: Obx(() {
                                if (controller.selectedImage.value != null) {
                                  return Image.file(
                                    File(controller.selectedImage.value!.path),
                                    width: 72,
                                    height: 72,
                                    fit: BoxFit.cover,
                                  );
                                }
                                return const Center(
                                  child: Icon(
                                    Icons.shopping_bag_outlined,
                                    color: Color(0xFF9CA3AF),
                                    size: 32,
                                  ),
                                );
                              }),
                            ),
                          ),
                          const SizedBox(width: 16),

                          // Product Name & Price / Details
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Obx(() {
                                  final name = controller.productName.value
                                      .trim();
                                  final link = controller.productLink.value
                                      .trim();
                                  final displayName = name.isNotEmpty
                                      ? name
                                      : (link.isNotEmpty
                                            ? link
                                            : 'Product Name');
                                  return Text(
                                    displayName,
                                    style: GoogleFonts.inter(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.onSurface,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  );
                                }),
                                const SizedBox(height: 6),
                                Obx(() {
                                  final priceText = controller
                                      .productPrice
                                      .value
                                      .trim();
                                  final displayPrice = priceText.isNotEmpty
                                      ? (priceText.startsWith('Rs.') ||
                                                priceText.startsWith('\$')
                                            ? priceText
                                            : 'Rs. $priceText')
                                      : 'Rs. 85,000';
                                  return Text(
                                    displayPrice,
                                    style: GoogleFonts.inter(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w800,
                                      color: AppColors.onSurface,
                                    ),
                                  );
                                }),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Three Decision Aspect Cards
                    Row(
                      children: [
                        _buildFeatureCard(
                          icon: Icons.psychology_outlined,
                          title: 'Urge Check',
                          subtitle: 'Identify\nemotional\nimpulse',
                        ),
                        const SizedBox(width: 10),
                        _buildFeatureCard(
                          icon: Icons.inventory_2_outlined,
                          title: 'Current Gear',
                          subtitle: 'Examine\nredundancies',
                        ),
                        const SizedBox(width: 10),
                        _buildFeatureCard(
                          icon: Icons.savings_outlined,
                          title: 'True Utility',
                          subtitle: 'Cost per\ndaily use',
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),

            // Bottom Actions & Privacy Section
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Continue CTA Button
                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton(
                      onPressed: () {
                        Get.toNamed(AppRoutes.questions);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Continue',
                            style: GoogleFonts.inter(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Icon(
                            Icons.arrow_forward_rounded,
                            size: 20,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Privacy text with lock icon
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.lock_outline_rounded,
                        size: 14,
                        color: Color(0xFF6B7280),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'YOUR RESPONSES REMAIN PRIVATE ON DEVICE',
                        style: GoogleFonts.inter(
                          fontSize: 10.5,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
                          color: const Color(0xFF6B7280),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureCard({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE5E7EB), width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.015),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 28, color: AppColors.primary),
            const SizedBox(height: 12),
            Text(
              title,
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: AppColors.onSurface,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 11,
                fontWeight: FontWeight.w400,
                color: const Color(0xFF6B7280),
                height: 1.3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
