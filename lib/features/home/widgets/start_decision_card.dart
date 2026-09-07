import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Call-to-action card to begin a new purchase evaluation
class StartDecisionCard extends StatelessWidget {
  final VoidCallback? onTap;

  const StartDecisionCard({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFEFF6F0), Color(0xFFF6F2EC)],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Should I buy something?",
            style: GoogleFonts.playfairDisplay(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Upload a product or tell us what you're considering to start analyzing your impulse.",
            style: GoogleFonts.inter(
              fontSize: 14,
              color: Colors.black54,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 18),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: onTap,
              icon: const Icon(Icons.add_circle_outline, size: 20),
              label: const Text("Start a decision"),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 39, 116, 41),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                textStyle: GoogleFonts.inter(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
