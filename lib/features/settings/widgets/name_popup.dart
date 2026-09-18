import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/settings_controller.dart';

/// Popup dialog for updating user name
class NamePopup extends StatefulWidget {
  const NamePopup({super.key});

  static Future<void> show(BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => const NamePopup(),
    );
  }

  @override
  State<NamePopup> createState() => _NamePopupState();
}

class _NamePopupState extends State<NamePopup> {
  final SettingsController controller = Get.find<SettingsController>();
  late final TextEditingController textController;
  late String currentName;

  @override
  void initState() {
    super.initState();
    currentName = controller.userName.value;
    textController = TextEditingController(text: currentName);
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  void _saveAndClose() {
    if (currentName.trim().isNotEmpty) {
      controller.updateName(currentName.trim());
    }
    Get.back();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Top Back/Close bar
              Align(
                alignment: Alignment.topLeft,
                child: InkWell(
                  onTap: () => Get.back(),
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    child: const Icon(
                      Icons.arrow_back,
                      size: 20,
                      color: Color(0xFF1C1B1B),
                    ),
                  ),
                ),
              ),

              // Visual Avatar Badge
              Center(
                child: Container(
                  width: 84,
                  height: 84,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8F7F0),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFFC7EFE0),
                      width: 2,
                    ),
                  ),
                  child: const Center(
                    child: Text(
                      '👋',
                      style: TextStyle(fontSize: 34),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 18),

              // Title
              Text(
                "First things first — what\nshould we call you?",
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF1C1B1B),
                  height: 1.25,
                ),
              ),
              const SizedBox(height: 8),

              // Subtitle
              Text(
                "WorthIt feels better when your decisions\nactually feel like yours.",
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: 13,
                  color: const Color(0xFF666666),
                  height: 1.35,
                ),
              ),
              const SizedBox(height: 24),

              // Name Input Field
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "YOUR NAME",
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.8,
                    color: const Color(0xFF4A5568),
                  ),
                ),
              ),
              const SizedBox(height: 8),

              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: currentName.trim().isNotEmpty
                        ? const Color.fromARGB(255, 39, 116, 41)
                        : const Color(0xFFDCDCDC),
                    width: 1.5,
                  ),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: textController,
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF1C1B1B),
                        ),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Enter your name',
                          isDense: true,
                        ),
                        onChanged: (val) {
                          setState(() {
                            currentName = val;
                          });
                        },
                        onSubmitted: (_) => _saveAndClose(),
                      ),
                    ),
                    if (currentName.trim().isNotEmpty)
                      const Icon(
                        Icons.check_circle_outline_rounded,
                        color: Color.fromARGB(255, 39, 116, 41),
                        size: 22,
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 14),

              // Greeting Chip Preview
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFFEAF8F1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: const Color(0xFFB7EBCE),
                    width: 1,
                  ),
                ),
                child: Text.rich(
                  TextSpan(
                    text: "✨ Nice to meet you, ",
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: const Color.fromARGB(255, 30, 95, 33),
                    ),
                    children: [
                      TextSpan(
                        text: currentName.trim().isNotEmpty
                            ? currentName.trim()
                            : "there",
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: const Color.fromARGB(255, 30, 95, 33),
                          decoration: TextDecoration.underline,
                        ),
                      ),
                      const TextSpan(text: " 👋"),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 24),

              // Done Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _saveAndClose,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 39, 116, 41),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child: Text(
                    "Done",
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
