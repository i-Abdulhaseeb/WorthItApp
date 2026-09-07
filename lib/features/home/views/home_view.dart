import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controllers/home_controller.dart';
import '../widgets/start_decision_card.dart';
import '../widgets/monthly_summary.dart';
import '../widgets/recent_decisions.dart';

/// Main Home view
class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBF6F2),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFBF6F2),
        elevation: 0,
        titleSpacing: 16,
        title: Text(
          "Verdict",
          style: GoogleFonts.playfairDisplay(
            color: const Color.fromARGB(255, 39, 116, 41),
            fontWeight: FontWeight.bold,
            fontSize: 26,
          ),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Icon(
              Icons.account_circle_outlined,
              size: 28,
              color: Colors.black87,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Good morning",
              style: GoogleFonts.playfairDisplay(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              "Ready to question your next purchase?",
              style: GoogleFonts.inter(fontSize: 15, color: Colors.black54),
            ),
            const SizedBox(height: 20),
            StartDecisionCard(onTap: controller.startDecision),
            const SizedBox(height: 20),
            Obx(
              () => MonthlySummary(
                decisions: controller.totalDecisions.length.toString(),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              "Recent Decisions",
              style: GoogleFonts.playfairDisplay(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 12),
            const RecentDecisions(),
          ],
        ),
      ),
    );
  }
}
