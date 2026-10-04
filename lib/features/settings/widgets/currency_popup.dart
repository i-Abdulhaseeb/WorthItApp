import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controllers/settings_controller.dart';

class CurrencyOption {
  final String countryCode;
  final String code;
  final String symbol;
  final String name;

  const CurrencyOption({
    required this.countryCode,
    required this.code,
    required this.symbol,
    required this.name,
  });
}

/// Popup dialog for selecting currency
class CurrencyPopup extends StatefulWidget {
  const CurrencyPopup({super.key});

  static Future<void> show(BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => const CurrencyPopup(),
    );
  }

  @override
  State<CurrencyPopup> createState() => _CurrencyPopupState();
}

class _CurrencyPopupState extends State<CurrencyPopup> {
  final SettingsController controller = Get.find<SettingsController>();

  final List<CurrencyOption> currencies = const [
    CurrencyOption(
      countryCode: 'PK',
      code: 'PKR',
      symbol: 'Rs',
      name: 'Pakistani Rupee',
    ),
    CurrencyOption(
      countryCode: 'US',
      code: 'USD',
      symbol: '\$',
      name: 'US Dollar',
    ),
    CurrencyOption(
      countryCode: 'GB',
      code: 'GBP',
      symbol: '£',
      name: 'British Pound',
    ),
    CurrencyOption(countryCode: 'EU', code: 'EUR', symbol: '€', name: 'Euro'),
  ];

  late String selectedCode;

  @override
  void initState() {
    super.initState();
    selectedCode = controller.selectedCurrencyCode.value;
    // Fallback if current string has currency info
    if (!currencies.any((c) => c.code == selectedCode)) {
      String curr = controller.currency.value;
      if (curr.contains('PKR')) {
        selectedCode = 'PKR';
      } else if (curr.contains('EUR')) {
        selectedCode = 'EUR';
      } else if (curr.contains('GBP')) {
        selectedCode = 'GBP';
      } else {
        selectedCode = 'USD';
      }
    }
  }

  void _saveAndClose() {
    final selected = currencies.firstWhere(
      (c) => c.code == selectedCode,
      orElse: () => currencies[1],
    );
    controller.updateCurrency(selected.code, selected.symbol, selected.name);
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
                        color: const Color(0xFFE8F7F0),
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
                      top: -2,
                      right: -2,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 5,
                          vertical: 2,
                        ),
                        decoration: const BoxDecoration(
                          color: Color.fromARGB(255, 30, 95, 33),
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        child: const Text(
                          'Rs',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),

              // Title
              Text(
                "What currency do you\nthink in?",
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
                "We'll use this for prices, budgets, affordability\nscores, and purchase insights.",
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: 13,
                  color: const Color(0xFF666666),
                  height: 1.35,
                ),
              ),
              const SizedBox(height: 24),

              // 2x2 Currency Grid (No search bar)
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 1.25,
                ),
                itemCount: currencies.length,
                itemBuilder: (context, index) {
                  final currency = currencies[index];
                  final isSelected = selectedCode == currency.code;

                  return InkWell(
                    onTap: () {
                      setState(() {
                        selectedCode = currency.code;
                      });
                      controller.updateCurrency(
                        currency.code,
                        currency.symbol,
                        currency.name,
                      );
                    },
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? const Color(0xFFEAF8F1)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isSelected
                              ? const Color.fromARGB(255, 39, 116, 41)
                              : const Color(0xFFE2E8F0),
                          width: isSelected ? 1.8 : 1,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                currency.countryCode,
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xFF718096),
                                ),
                              ),
                              if (isSelected)
                                const Icon(
                                  Icons.check_circle,
                                  size: 18,
                                  color: Color.fromARGB(255, 30, 95, 33),
                                )
                              else
                                Container(
                                  width: 18,
                                  height: 18,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: const Color(0xFFCBD5E0),
                                      width: 1.5,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                currency.code,
                                style: GoogleFonts.inter(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w800,
                                  color: const Color(0xFF1C1B1B),
                                ),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                currency.symbol,
                                style: GoogleFonts.inter(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: isSelected
                                      ? const Color.fromARGB(255, 30, 95, 33)
                                      : const Color(0xFF718096),
                                ),
                              ),
                            ],
                          ),
                          Text(
                            currency.name,
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              color: const Color(0xFF718096),
                              fontWeight: FontWeight.w500,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 14),

              // Settings hint text
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.tune, size: 14, color: Color(0xFF718096)),
                  const SizedBox(width: 6),
                  Text(
                    "More currencies available in Settings",
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: const Color(0xFF718096),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

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
