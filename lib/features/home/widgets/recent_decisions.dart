import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Recent purchasing decisions list widget (hardcoded)
class RecentDecisions extends StatelessWidget {
  const RecentDecisions({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
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
        children: [
          _buildItem(
            icon: Icons.headphones_outlined,
            title: "Sony WH-1000XM6",
            price: "Rs. 85,000",
            badgeText: "WAIT",
            badgeColor: const Color(0xFFE8963C),
          ),
          const Divider(height: 1, indent: 16, endIndent: 16),
          _buildItem(
            icon: Icons.shopping_bag_outlined,
            title: "Nike Air Max",
            price: "Rs. 24,000",
            badgeText: "DON'T BUY",
            badgeColor: const Color(0xFFD9534F),
          ),
          const Divider(height: 1, indent: 16, endIndent: 16),
          _buildItem(
            icon: Icons.keyboard_outlined,
            title: "Mechanical Keyboard",
            price: "Rs. 18,500",
            badgeText: "BUY",
            badgeColor: const Color.fromARGB(255, 39, 116, 41),
          ),
        ],
      ),
    );
  }

  Widget _buildItem({
    required IconData icon,
    required String title,
    required String price,
    required String badgeText,
    required Color badgeColor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor: const Color(0xFFF1EEEA),
            child: Icon(icon, color: Colors.black54, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  price,
                  style: GoogleFonts.inter(fontSize: 13, color: Colors.black54),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              border: Border.all(color: badgeColor.withOpacity(0.5)),
              borderRadius: BorderRadius.circular(20),
              color: badgeColor.withOpacity(0.08),
            ),
            child: Text(
              badgeText,
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: badgeColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
