import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Single item tile in settings view
class SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? value;
  final bool showChevron;
  final VoidCallback? onTap;

  const SettingsTile({
    super.key,
    required this.icon,
    required this.title,
    this.value,
    this.showChevron = true,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap ?? () {},
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
          child: Row(
            children: [
              Icon(
                icon,
                size: 22,
                color: const Color(0xFF5F6B7A),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  title,
                  style: GoogleFonts.inter(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF1C1B1B),
                  ),
                ),
              ),
              if (value != null) ...[
                Text(
                  value!,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF5F6368),
                  ),
                ),
                if (showChevron) const SizedBox(width: 6),
              ],
              if (showChevron)
                const Icon(
                  Icons.chevron_right_rounded,
                  size: 20,
                  color: Color(0xFF718096),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

