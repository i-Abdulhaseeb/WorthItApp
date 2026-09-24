import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/utils/responsive.dart';
import '../controllers/home_controller.dart';
import '../widgets/start_decision_card.dart';
import '../widgets/monthly_summary.dart';
import '../widgets/recent_decisions.dart';

/// Main Home view
class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final horizontalPad = Responsive.horizontalPadding(context);

    return Scaffold(
      backgroundColor: const Color(0xFFFBF6F2),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFBF6F2),
        elevation: 0,
        titleSpacing: horizontalPad,
        title: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: Responsive.maxContentWidth),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Verdict",
                  style: GoogleFonts.playfairDisplay(
                    color: const Color.fromARGB(255, 39, 116, 41),
                    fontWeight: FontWeight.bold,
                    fontSize: 26,
                  ),
                ),
                const Icon(
                  Icons.account_circle_outlined,
                  size: 28,
                  color: Colors.black87,
                ),
              ],
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(horizontalPad, 8, horizontalPad, 24),
          child: ResponsiveCenter(
            maxWidth: Responsive.maxContentWidth,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Obx(
                  () => Text(
                    controller.greeting.value,
                    style: GoogleFonts.playfairDisplay(
                      fontSize: Responsive.isCompact(context) ? 28 : 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  "Ready to question your next purchase?",
                  style: GoogleFonts.inter(
                    fontSize: Responsive.isCompact(context) ? 14 : 15,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 20),
                StartDecisionCard(onTap: controller.startDecision),
                const SizedBox(height: 20),
                Obx(
                  () => MonthlySummary(
                    decisions: controller.totalDecisions.toString(),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  "Recent Decisions",
                  style: GoogleFonts.playfairDisplay(
                    fontSize: Responsive.isCompact(context) ? 20 : 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 12),
                const RecentDecisions(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
