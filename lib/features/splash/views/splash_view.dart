import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/splash_controller.dart';
import '../widgets/splash_decorations.dart';

/// Splash screen view displayed on app startup.
class SplashView extends GetView<SplashController> {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF9F6),
      body: Stack(
        children: [
          // Background ambient glows and decorative curves
          const Positioned.fill(
            child: CustomPaint(
              painter: SplashBackgroundPainter(),
            ),
          ),

          // Main splash content
          SafeArea(
            child: Column(
              children: [
                const Spacer(flex: 2),

                // 3D Illustration / Balance Logo
                Image.asset(
                  'assets/images/splash_logo.png',
                  width: MediaQuery.of(context).size.width * 0.72,
                  fit: BoxFit.contain,
                ),

                const SizedBox(height: 28),

                // App Brand Name with Emerald Dot
                RichText(
                  text: TextSpan(
                    style: GoogleFonts.inter(
                      fontSize: 38,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.8,
                      color: const Color(0xFF13221C),
                    ),
                    children: const [
                      TextSpan(text: 'WorthIt'),
                      TextSpan(
                        text: '.',
                        style: TextStyle(
                          color: Color(0xFF008955),
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 14),

                // Subtitle / Question Tagline
                Text(
                  'Before you buy it...\nask if it’s worth it.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    height: 1.45,
                    letterSpacing: 0.2,
                    color: const Color(0xFF6B7C72),
                  ),
                ),

                const Spacer(flex: 3),

                // Bottom Divider with Center Green Leaf
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Left divider line
                    Container(
                      width: 36,
                      height: 1.2,
                      color: const Color(0xFFCCD8D0),
                    ),
                    const SizedBox(width: 14),

                    // Sprouting Leaf Icon
                    const SizedBox(
                      width: 16,
                      height: 14,
                      child: CustomPaint(
                        painter: LeafSproutPainter(
                          color: Color(0xFF007A4D),
                        ),
                      ),
                    ),

                    const SizedBox(width: 14),
                    // Right divider line
                    Container(
                      width: 36,
                      height: 1.2,
                      color: const Color(0xFFCCD8D0),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // Bottom Brand Philosophy Tagline
                Text(
                  'SMARTER DECISIONS  •  BETTER YOU',
                  style: GoogleFonts.inter(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 2.2,
                    color: const Color(0xFF7A8D83),
                  ),
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
