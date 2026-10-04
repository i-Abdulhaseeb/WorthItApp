import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/settings_controller.dart';

/// Popup dialog for updating monthly income
class IncomePopup extends StatefulWidget {
  const IncomePopup({super.key});

  static Future<void> show(BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => const IncomePopup(),
    );
  }

  @override
  State<IncomePopup> createState() => _IncomePopupState();
}

class _IncomePopupState extends State<IncomePopup> {
  final SettingsController controller = Get.find<SettingsController>();
  late final TextEditingController textController;
  late String currentAmount;
  String? selectedPreset;

  final List<String> presets = ['50,000', '85,000', '120,000', '200,000+'];

  @override
  void initState() {
    super.initState();
    // Extract numerical part from current income string (e.g. "$6,200 / mo" -> "6,200")
    String raw = controller.income.value
        .replaceAll(RegExp(r'[^\d,+]'), '')
        .trim();
    currentAmount = raw.isNotEmpty ? raw : '85,000';
    if (presets.contains(currentAmount)) {
      selectedPreset = currentAmount;
    }
    textController = TextEditingController(text: currentAmount);
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  String _getCurrencyCode() {
    return controller.selectedCurrencyCode.value;
  }

  String _getCurrencySymbol() {
    String curr = controller.currency.value;
    if (curr.contains('USD') || curr.contains('\$')) return '\$';
    if (curr.contains('PKR') || curr.contains('Rs')) return 'PKR ';
    if (curr.contains('EUR') || curr.contains('€')) return '€';
    if (curr.contains('GBP') || curr.contains('£')) return '£';
    return '\$';
  }

  void _saveAndClose() {
    String clean = currentAmount.trim();
    if (clean.isNotEmpty) {
      String symbol = _getCurrencySymbol();
      controller.updateIncome('$symbol$clean / mo');
    }
    Get.back();
  }

  @override
  Widget build(BuildContext context) {
    String currencyCode = _getCurrencyCode();
    String currencySymbol = _getCurrencySymbol();

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
              // Top Back button
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

              // Visual Badge
              Center(
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      width: 68,
                      height: 68,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8F0EA),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.account_balance_wallet_outlined,
                          size: 32,
                          color: Color.fromARGB(255, 30, 95, 33),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: -2,
                      right: -2,
                      child: Container(
                        padding: const EdgeInsets.all(3),
                        decoration: const BoxDecoration(
                          color: Color.fromARGB(255, 30, 95, 33),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.trending_up,
                          size: 14,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),

              // Title
              Text(
                "Let's understand your\nspending power.",
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
                "This helps WorthIt judge whether a purchase\ncomfortably fits your finances — not just\nwhether you can technically afford it.",
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: 13,
                  color: const Color(0xFF666666),
                  height: 1.35,
                ),
              ),
              const SizedBox(height: 20),

              // Main Income Input Box
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: const Color.fromARGB(255, 39, 116, 41),
                    width: 1.5,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Monthly income",
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            color: const Color(0xFF718096),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 3),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE8F5EE),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            currencyCode,
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: const Color.fromARGB(255, 30, 95, 33),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          currencySymbol,
                          style: GoogleFonts.inter(
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF4A5568),
                          ),
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: TextField(
                            controller: textController,
                            keyboardType: TextInputType.text,
                            style: GoogleFonts.inter(
                              fontSize: 28,
                              fontWeight: FontWeight.w800,
                              color: const Color(0xFF1C1B1B),
                            ),
                            decoration: const InputDecoration(
                              isDense: true,
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.zero,
                              hintText: '0',
                            ),
                            onChanged: (val) {
                              setState(() {
                                currentAmount = val;
                                selectedPreset = presets.contains(val) ? val : null;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),

              // Quick Preset Chips
              Row(
                children: presets.map((preset) {
                  final isSelected = selectedPreset == preset || currentAmount == preset;
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 3),
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            selectedPreset = preset;
                            currentAmount = preset;
                            textController.text = preset;
                          });
                        },
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? const Color(0xFFEAF8F1)
                                : Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: isSelected
                                  ? const Color.fromARGB(255, 39, 116, 41)
                                  : const Color(0xFFE2E8F0),
                              width: isSelected ? 1.5 : 1,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              preset,
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                fontWeight: isSelected
                                    ? FontWeight.w700
                                    : FontWeight.w500,
                                color: isSelected
                                    ? const Color.fromARGB(255, 30, 95, 33)
                                    : const Color(0xFF2D3748),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 14),

              // Privacy Note
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: const Color(0xFFF7FAFC),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: const Color(0xFFEDF2F7),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.lock_outline_rounded,
                      size: 16,
                      color: Color.fromARGB(255, 30, 95, 33),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        "Private & only used to personalize your decisions",
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF718096),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),

              // Settings hint text
              Text(
                "You can change this anytime in Settings.",
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: const Color(0xFF718096),
                ),
              ),
              const SizedBox(height: 18),

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
