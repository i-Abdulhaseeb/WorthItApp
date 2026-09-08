import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:worthitapp/app/theme/app_colors.dart';
import 'package:worthitapp/features/purchase/controllers/purchase_controller.dart';

class EvaluationProgress extends StatelessWidget {
  final PurchaseController purchaseController;

  const EvaluationProgress({super.key, required this.purchaseController});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Obx(
          () => Text(
            'STEP ${purchaseController.currentStep.value} OF ${purchaseController.totalSteps}',
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.5,
              color: AppColors.primary,
            ),
          ),
        ),
        Text(
          'Evaluation Ready',
          style: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF6D7A72),
          ),
        ),
      ],
    );
  }
}
