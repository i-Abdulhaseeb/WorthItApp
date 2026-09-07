import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Monthly spending and savings summary widget (hardcoded)
class MonthlySummary extends StatelessWidget {
  const MonthlySummary({super.key, required this.decisions});
  final String decisions;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "THIS MONTH",
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.0,
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 14),
          _buildRow(
            label: "Decisions",
            value: decisions,
            valueStyle: GoogleFonts.playfairDisplay(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const Divider(height: 28),
          _buildRow(
            label: "Saved",
            value: "Rs. 42,500",
            valueStyle: GoogleFonts.playfairDisplay(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: const Color.fromARGB(255, 39, 116, 41),
            ),
          ),
          const Divider(height: 28),
          _buildRow(
            label: "Avoided",
            value: "63%",
            valueStyle: GoogleFonts.playfairDisplay(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRow({
    required String label,
    required String value,
    required TextStyle valueStyle,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(fontSize: 15, color: Colors.black54),
        ),
        Text(value, style: valueStyle),
      ],
    );
  }
}
